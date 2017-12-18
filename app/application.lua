
--[[
title: application entry
author: chenqh
date: 2017/12/10
desc: basic handler for web application, will handle all client requestes
]]

local Dispatcher = commonlib.gettable("Dove.Middleware.Dispatcher")

local function activate()
	Dispatcher.handle(msg)
end

NPL.this(activate)
