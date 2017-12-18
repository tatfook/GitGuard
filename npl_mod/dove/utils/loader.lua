--[[
title: file loader
author: chenqh
date: 2017/12/13
desc:
]]

local lfs = commonlib.Files.GetLuaFileSystem()
local _M = commonlib.gettable("Dove.Utils.Loader")

function _M.load_files(basedir, patterns)
    if(patterns == nil) then patterns = {".lua$", ".npl$"} end
    if(type(patterns) == "string") then patterns = {patterns} end

    for entry in lfs.dir(basedir) do
        if entry ~= '.' and entry ~= '..' then
            local path = basedir .. '/' .. entry
            local attr = lfs.attributes(path)
            if(not (type(attr) == 'table')) then
              error("get attributes of '" .. path .. "' failed.")
            end

            if attr.mode == 'directory' then
                _M.load_files(path, pattern)
            else
                for _, pattern in ipairs(patterns) do
                    if (path:match(pattern)) then
                        print("load: " .. path)
                        NPL.load(path)
                        break
                    end
                end
            end
        end
    end
end
