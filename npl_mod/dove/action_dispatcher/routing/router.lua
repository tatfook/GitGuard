--[[
title: router middleware
author: chenqh
date: 2017/12/10
desc: router middleware to parse router
]]

NPL.load("./regex_helper")
NPL.load("./rule")
NPL.load("./route")

local StringHelper = commonlib.gettable("Dove.Utils.StringHelper")
local Route = commonlib.gettable("ActionDispatcher.Routing.Route")
local _M = commonlib.gettable("ActionDispatcher.Routing.Router")

function _M.handle(ctx)
    local request = ctx.request
    local url = request:url()
    local method = request:GetMethod()
    local params = request:getparams() or {}
    local rule = Route.parse(method, url)
    ctx.params = rule:complete_extra_params(url, params)
    ctx.rule = rule
end

function _M.url_for(url, method, params)
    if(type(url) ~= "string") then error("invalid path") end
    local rule = Route.find_rule(url, method, params)
    if(not rule) then error("Invalid params to generate url") end
    return rule:generate_url(params)
end
