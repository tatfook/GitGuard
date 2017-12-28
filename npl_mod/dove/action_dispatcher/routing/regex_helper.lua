--[[
title: regex helper
author: chenqh
date: 2017/12/11
]]

local _M = commonlib.gettable("ActionDispatcher.Routing.RegexHelper")

function _M.is_formal(source)
    local input = source
    if(input:sub(1,1) == "^" and input:sub(input:len()) == '$') then return true end
    return false
end

function _M.formulize(source)
    local input = source
    if(_M.is_formal(input)) then return input end
    -- replace all :*_id to %w*
    input = input:gsub(":%a*id", "%%w+")
    input = input:gsub("/?$", "/?")
    -- add ^ and $
    return format("^%s$", input)
end
