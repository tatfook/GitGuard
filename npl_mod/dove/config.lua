--[[
title: dove config
author: chenqh
date: 2017/12/11
]]

local Config = commonlib.inherit(nil, "Dove.Config")

Config.env = "development" --default
Config.port = 8088

function Config:load_env()
    NPL.load("config/enviroments/" .. Config.env)
    print("load: " .. "config/enviroments/" .. Config.env)
end
