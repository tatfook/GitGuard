--[[
title: current application info
]]
NPL.load_package("dove")
NPL.load("dove/init") -- important: load dove application framework
local App = commonlib.inherit(Dove.Application, "Application")

App.config.name = "Git Guard"
