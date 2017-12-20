local _M = commonlib.inherit("Dove.Module", "Module.Controller.Filter")
local table_insert = table.insert

function _M.import_into(class)
    local _C = class

    _C.filter_types = {before = "before_filters", after = "after_filters"}
    _C.before_filters = {}
    _C.after_filters = {}
    _C.before_each_filters = {}
    _C.after_each_filters = {}

    function _C.before_each(...)
        local args = {...}
        for _, filter in ipairs(args) do
            table_insert(_C.before_each_filters, filter)
        end
    end

    function _C.after_each(...)
        local args = {...}
        for _, filter in ipairs(args) do
            table_insert(_C.before_each_filters, filter)
        end
    end

    function _C.before_filter(filters, actions)
        for _, filter in ipairs(filters) do
            _C.add_filter_to_actions(filter, "before", actions)
        end
    end

    function _C.after_filter(filters, actions)
        for _, filter in ipairs(filters) do
            _C.add_filter_to_actions(filter, "after", actions)
        end
    end

    function _C.add_filter_to_actions(filter, filter_type, actions)
        local filter_name = _C.filter_types[filter_type:lower()]
        if(filter_name == nil) then error("Invalid filter type: " .. filter_type) end
        local filters = _C[filter_name]
        for _, action in ipairs(actions) do
            table_insert(filters[action], filter)
        end
    end

    function _C:execute_filters(filters, action)
        for _, func in ipairs(filters[action] or {}) do
            self:execute_function(func)
        end
    end

    function _C:execute_function(func)
        if(type(self[func]) == "function") then
            return self[func](self)
        else
            error("Invalid function: " .. func .. " in controller " .. self.resource_name)
        end
    end

    -- run action during filters
    -- please note the 'each' filter will always run before other filters
    -- for example: before_each filters will run before before_filters
    function _C:execute_with_filters(action)
        self.execute_filters(self.before_each_filters or {}, action)
        self:execute_filters(self.before_filters or {}, action)
        self.ctx.data = self:execute_function(action)
        self.execute_filters(self.after_each_filters or {}, action)
        self:execute_filters(self.after_filters or {}, action)
    end

    return _C
end
