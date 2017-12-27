--[[
title: string helper
author: chenqh
date: 2017/12/17
]]

local _M = commonlib.gettable("Dove.Utils.StringHelper")
local table_insert = table.insert

function _M.camelize(str)
    return str:gsub("[-_](%w)", string.upper)
end

function _M.capitalize(word)
    return word:sub(1,1):upper() .. word:sub(2, #word)
end

function _M.classify(str)
    return _M.capitalize(_M.camelize(str))
end

--[[
example:
str = "hello#world"
pattern = "[^#]+"
split(str, pattern) will return {"hello", "world"}
]]
function _M.split(str, pattern)
    local arr = {}
    for part in str:gmatch(pattern) do
        table_insert(arr, part)
    end
    return arr
end