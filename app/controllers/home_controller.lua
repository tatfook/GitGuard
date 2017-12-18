--[[
Title:  home controller
Author: chenqh
Date:   2017/12/18
]]

local _C = commonlib.inherit(Dove.Controller.Base, "Controller.Home")

function _C:index()
    self.response:send("Hello, I'm the guard!")
end