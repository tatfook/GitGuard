--[[
title: dove enviroment
author: chenqh
date: 2017/12/10
desc: a wrapper including request and response, will pass through all middleware
]]


local _M = commonlib.inherit(nil, "Dove.Middleware.Enviroment")

function _M:ctor()
end

function _M:init(req)
    if(req == nil) then error("Invalid Request!") end
    self.request = req
    self.response = req.response
end
