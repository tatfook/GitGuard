--[[
title: dove app framework middleware dispatcher
author: chenqh
date: 2017/12/10
desc: handle middlewares in pipeline
]]

NPL.load("./dispatcher")

local base = commonlib.inherit(nil, "Dove.Middleware.Base")

function base.handle(env)
    error("must implement the 'handle' method for your middleware")
end

function base.info()
    -- return middleware info
end