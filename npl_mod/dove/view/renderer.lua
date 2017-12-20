--[[
title: dove renderer
author: chenqh
date: 2017/12/14
]]

local _M = commonlib.gettable("Dove.Renderer")
local Pluralize = commonlib.gettable("Dove.Utils.Pluralize")
local PathHelper = commonlib.gettable("Dove.Utils.PathHelper")
local json_encode = commonlib.Json.Encode
local table_insert = table.insert

_M.default_template = require("./resty/template")
_M.default_template_file = ".html"

local function file_exists(path)
	return ParaIO.DoesFileExist(path, false);
end

function _M.render(ctx)
    if(ctx.is_render) then return end

    if(ctx.request:IsJsonBody()) then
        _M.render_json(ctx)
    else
        _M.render_template(ctx)
    end

    ctx.is_render = true
end

function _M.render_json(ctx)
    ctx.response:send(json_encode(ctx.data))
end

function _M.render_template(ctx)
    if(not ctx.view) then _M.load_default_view(ctx) end

    if(not file_exists(ctx.view)) then
        _M.error_page(ctx, 404)
        return
    end

    local template = APP.config.template or _M.default_template
    local context = ctx.data or {}
    context.ctx = ctx

    local body = template.render(ctx.view, context)

    ctx.response:set_header('Content-Type', 'text/html;charset=utf-8')
    ctx.response:sendsome(body)
end

function _M.error_page(ctx, code)
    if(not code) then code = "error" end
    local view = "app/view/" .. tostring(code) .. ".html"

    if(not file_exists(view)) then
        if (APP.config.env ~= "production") then
            print("error: 404.html not found")
            ctx.response:status(404):send(string.format([[<html><body>404.html not found</html>]]))
            ctx.response:finish()
        else
            print("error: " .. code .. ".html not found")
            ctx.response:status(500):send([[<html><head><title>error</title></head>
        <body>server error</body></html>]])
            ctx.response:finish()
        end
    else
        ctx.response:status(302):set_header("Location", "/" .. code)
        ctx.response:send("")
    end
end

function _M.load_default_view(ctx)
    if(ctx.view ~= nil) then return ctx.view end
    local path_stack = {"app/views"}
    local base_path = ctx.rule.controller:lower():gsub("^controller.", "")

    for path in base_path:gmatch("%w+") do
        table_insert(path_stack, path)
    end

    path_stack[#path_stack] = Pluralize.plural(path_stack[#path_stack])

    local template_file = APP.config.template_file or _M.default_template_file
    table_insert(path_stack, ctx.rule.action .. template_file)

    local file_path = PathHelper.concat_table(path_stack)

    ctx.view = file_path
end