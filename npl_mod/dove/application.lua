--[[
title: application entry
author: chenqh
date: 2017/12/10
desc: basic handler for web application, will handle all client requestes
]]

local dispatcher = commonlib.gettable("dove.middleware.dispatcher")

dispatcher.handle(request)
