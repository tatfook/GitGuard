local _M = commonlib.inherit(nil, "Dove.Module")

function _M.import_into(class)
    error("Please implement the module code")
end

function _M.import(class, module)
    if(type(module) == "string") then
        module = commonlib.gettable(module)
    end
    if(type(module) == "table" and type(module.import_into) == "function") then
        module.import_into(class)
    else
        error("Invalid Module")
    end
end
