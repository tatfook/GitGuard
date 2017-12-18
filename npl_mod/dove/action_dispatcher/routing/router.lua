--[[
title: router middleware
author: chenqh
date: 2017/12/10
desc: router middleware to parse router
]]

NPL.load("./route")

local Route = commonlib.gettable("ActionDispatcher.Routing.Route")
local _M = commonlib.gettable("ActionDispatcher.Routing.Router")

local function complete_extra_params(params, url, url_rule)
    local extra_keys = url_rule:match(":%w*_id")
    if(extra_keys == nil or #extra_keys == 0) then return params end

    local url_rule_fragments = url_rule:gmatch("/")
    local url_fragments = url_rule:gmatch("/")

    for index, key in ipairs(url_rule_fragments) do
        if(key:match("^:%w*_id$")) then
            table.insert(params, url_fragments[index])
        end
    end
    return params
end

function _M.handle(ctx)
    local request = ctx.request
    local path = request:url()
    local method = request:GetMethod()
    local params = request:getparams() or {}
    local rule = Route.parse(method, path)
    ctx.params = complete_extra_params(params, path, rule.url)
    ctx.rule = rule
end
