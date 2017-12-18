
--[[
Title: base class of all controllers
Author: Chenqh
Date: 2017/11/22
Desc: model converts from database rows to objects.
virtual functions: index, show, create, destroy, update
]]

local _M = commonlib.inherit(nil, "Dove.Controller.Base")
_M.resource_name = "unnamed"
_M.filter_types = {before = "before_filters", after = "after_filters"}
_M.before_filters = {}
--[[ define before filters, will execute those methods before the action
_M.before_filters = {
    "action name"= {} -- method array
    ...
}
]]
_M.after_filters = {}
--[[ define after filters, will execute those methods after the action
_M.after_filters = {
    "action name" = {} -- method array
    ...
}
]]

local table_insert = table.insert

function _M:add_filter_to_actions(filter, filter_type, actions)
    local filter_name = self.filter_types[filter_type:lower()]
    if(filter_name == nil) then error("Invalid filter type: " .. filter_type) end
    local filters = self[filter_name]
    for _, action in ipairs(actions) do
        table_insert(filters[action], filter)
    end
end

function _M:execute_filters(filters, action)
    for _, func in ipairs(filters[action] or {}) do
        self:execute_function(func)
    end
end

function _M:execute_function(func)
    if(type(self[func]) == "function") then
        self[func](self)
    else
        error("Invalid function: " .. func .. " in controller " .. self.resource_name)
    end
end

function _M:ctor()
end

function _M:init(env)
    self.env = env
    self.params = env.params
    self.request = env.request
    self.response = env.response

    self.have_resource = true
    if(self.resource_name == "unnamed") then
        self.have_resource = false
        return
    end
    self.Resource = commonlib.gettable("Model." .. Dove.Utils.StringHelper.classify(self.resource_name))
    if(self.Resource == nil) then
        error("invalid resource name: " .. self.resource_name)
    end
end

function _M:handle(action)
    self:execute_filters(self.before_filters or {}, action)
    self:execute_function(action)
    self:execute_filters(self.after_filters or {}, action)
end

function _M:index()
    if(self.have_resource) then
        result = self.resource.get(self.params)
    end
end

function _M:show()

end

function _M:create()

end

function _M:update()

end

function _M:delete()

end

