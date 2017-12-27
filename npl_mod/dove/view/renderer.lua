--[[
title: dove renderer
author: chenqh
date: 2017/12/14
]]
local _M = commonlib.gettable("Dove.View.Renderer")
local json_encode = commonlib.Json.Encode

_M.default_template = require("./resty/template")
_M.default_template_file = ".html"

local function file_exists(path)
	return ParaIO.DoesFileExist(path, false);
end

function _M.render_json(ctx, data)
    return json_encode(data)
end

function _M.render_template(ctx, data, path)
    if(not file_exists(path)) then
        _M.error_page(ctx, 404)
        erro("template not exist: " .. path)
    end

    local template = APP.config.template or _M.default_template
    local context = data or {}
    context.ctx = ctx
    context.helper = Dove.View.Helper
    context.H = Dove.View.Helper

    local content = template.render(path, context)
    return content
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
