--[[
title: application luancher
author: chenqh
date: 2017/12/10
]]

NPL.load("(gl)script/apps/WebServer/WebServer.lua")
NPL.load("./config/application")
local Application = commonlib.gettable("GitGuard.Application")

APP = Application:new()
APP.config.env = ParaEngine.GetAppCommandLineByParam("env", "development")
local port = ParaEngine.GetAppCommandLineByParam("port", 8088)
APP:start("app", "0.0.0.0", port)

NPL.this(function() end)
