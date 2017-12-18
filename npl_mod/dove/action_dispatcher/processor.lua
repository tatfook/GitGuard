--[[
title: action processor
author: chenqh
date: 2012/12/14
desc: manage the workflow of dove mvc
]]

NPL.load("./routing/router")

local _M = commonlib.inherit(Dove.Middleware.Base, "ActionDispatcher.Processor")
local Router = commonlib.gettable("ActionDispatcher.Routing.Router")

function _M.handle(ctx)
    Router.handle(ctx)
    local controller = commonlib.gettable(ctx.rule.controller):new()
    controller:init(ctx)
    controller:handle(ctx.rule.action)
end
