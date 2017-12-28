--[[
title: dove app framework marshal Dispatcher
author: chenqh
date: 2017/12/10
desc: dove marshal Dispatcher, handle all middlewares in pipeline
]]

local _M = commonlib.gettable("Dove.Middleware.Dispatcher")

_M.pipeline = {}
_M.services = {}

local function add_to_pipeline(middleware)
    _M.pipeline[#_M.pipeline + 1] = middleware
end

local function add_service(middleware, lib)
    if(_M.services[middleware] ~= nil) then
        log(format("warning: service %s already existed, please check if there are some mistakes.", middleware))
    end
    _M.services[middleware] = lib
end

local function traversal(env)
    for _, middleware in ipairs(_M.pipeline) do
        _M.services[middleware].handle(env)
    end
end

-- middleware is a string, the name of the middleware lib
function _M.register(middleware)
    if(type(middleware) ~= "string") then error("please register with the middleware class name") end
    local middleware_lib = commonlib.gettable(middleware)
    if(type(middleware_lib) ~= "table") then error("Invalid middleware!") end
    if(type(middleware_lib.handle) ~= "function") then error(format("please implement 'handle' method for middleware %s", middleware)) end
    if(_M.services[middleware] ~= nil) then
        log(format("warning: service %s already existed, will ignore it.", middleware))
        return
    end
    add_to_pipeline(middleware)
    add_service(middleware, middleware_lib)
    log(format("middleware %s loaded!\n", middleware))
end

function _M.handle(ctx)
    xpcall(
        function()
            traversal(ctx)
        end,
        function(e)
            log("error: Dispatcher.traversal failed.")
            log(e)
            log(debug.traceback())
            ctx.response:send(format("exception: %s \n debug: %s", e ,debug.traceback()))
        end
    )

    if (string.find(ctx.response.statusline, "302")) then
        ctx.response:send("")
    elseif (ctx.request._isAsync) then
        log("a async request.")
    else
        ctx.response:finish()
        ctx.response:End()
    end
end
