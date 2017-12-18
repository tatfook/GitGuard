--[[
title: dove config
author: chenqh
date: 2017/12/11
]]

local config = commonlib.gettable("dove.config")

config.env = "development"

function config.set_env(env)
    self.env = env
end

function config.load_env()
    if(self.env == "test") then
    elseif(self.env == "production") then
    else -- default is development
    end
end