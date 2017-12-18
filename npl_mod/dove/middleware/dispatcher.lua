--[[
title: dove app framework marshal Dispatcher
author: chenqh
date: 2017/12/10
desc: dove marshal Dispatcher, handle all middlewares in pipeline
]]

NPL.load("./enviroment")
local Enviroment = commonlib.gettable("Dove.Middleware.Enviroment")
local _M = commonlib.gettable("Dove.Middleware.Dispatcher")

_M.pipeline = {}
_M.services = {}

local function add_to_pipeline(middleware)
    _M.pipeline[#_M.pipeline + 1] = middleware
end

local function add_service(middleware, lib)
    if(_M.services[middleware] ~= nil) then
        log("warning: service " .. middleware .. " already existed, please check if there are some mistakes.")
    end
    _M.services[middleware] = lib
end

local function traversal(env)
    print("go traversal ==============")
    for _, middleware in ipairs(_M.pipeline) do
        _M.services[middleware].handle(env)
    end
end

-- middleware is a string, the name of the middleware lib
function _M.register(middleware)
    if(type(middleware) ~= "string") then error("please register with the middleware class name") end
    local middleware_lib = commonlib.gettable(middleware)
    if(type(middleware_lib) ~= "table") then error("Invalid middleware!") end
    if(type(middleware_lib.handle) ~= "function") then error("please implement 'handle' method for middleware " .. middleware) end
    if(_M.services[middleware] ~= nil) then
        log("warning: service " .. middleware .. " already existed, will ignore it.")
        return
    end
    add_to_pipeline(middleware)
    add_service(middleware, middleware_lib)
    log("middleware " .. middleware .. " loaded!\n")
end

function _M.handle(msg)
    local req = WebServer.request:new():init(msg)

    local env = Enviroment:new()
    env:init(req)

    xpcall(
        function()
            traversal(env)
        end,
        function(e)
            print("error: Dispatcher.traversal failed.")
            print(e)
            print(debug.traceback())
        end
    )

    if (string.find(req.response.statusline, "302")) then
        req.response:send("")
    elseif (req._isAsync) then
        print("a async request.")
    else
        req.response:finish()
        req.response:End()
    end
end
