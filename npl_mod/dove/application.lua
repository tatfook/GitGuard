--[[
title: application entry
author: chenqh
date: 2017/12/10
desc: basic handler for web application, will handle all client requestes
]]

local App = commonlib.inherit(nil, "Dove.Application")
local Loader = commonlib.gettable("Dove.Utils.Loader")
local Dispatcher = commonlib.gettable("Dove.Middleware.Dispatcher")

App.config = {
    env = "development",
    port = "8088",
    layout = {
        default_template = "application_layout",
        enable = true
    }
    -- default_template = nil
    -- default_template_file = nil
}

function App:ctor()
end

local function load_app()
    Loader.load_files("app/controllers")
    Loader.load_files("app/models")
    Loader.load_files("config/initializers")
end

function App:info()
end

function App:start()
    NPL.load("config/enviroment/" .. self.config.env)
    load_app()
    -- 启动web服务器
    WebServer:Start("app", "0.0.0.0", self.config.port)
end

function App:handle(msg)
    local req = WebServer.request:new():init(msg)
    local ctx = Dove.Context:new()
    ctx:init(req)
    Dispatcher.handle(ctx)
end