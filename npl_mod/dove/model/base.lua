
--[[
Title: base class of all models
Author: chenqh
Date: 2017/12/6
Desc: model converts from database rows to objects.
base functions: get, create, delete, update
]]

local _M = commonlib.inherit(nil, "Dove.Model.Base")
_M.resource_name = "unnamed"
_M.attributes = {}
_M.orm = nil

function _M:ctor()
	if(self.resource_name == nil) then error("invalid model name: nil") end
	-- if(self.orm == nil) then error("invalid orm: nil") end
end

function _M:execute_filters(filters)
    for _, method_name in ipairs(filters or {}) do
        self[method_name](self)
    end
end

function _M:add_attribute(attribute)
	self.attributes[attribute.name] = attribute
	self[attribute.name] = attribute.default
end

function _M:add_attributes(attributes)
	for _, attribute in ipairs(attributes) do
		self:add_attribute(attribute)
	end
end

function _M:build(attributes)
	for attr, value in pairs(attributes) do
		local attribute = self.attributes[attr]
		if(attribute ~= nil) then
			if(type(value) ~= attribute.type) then -- TODO: auto convert
				error(format("Invalid type of %s, expect is %s, but get %s", attribute.name, attribute.type, type(value)))
			end
			self[attr] = value
		end
	end
	return self
end

function _M:save()
	if(self:is_create()) then self:execute_filters(self.before_create) end
	self:execute_filters(self.before_save)
	if(self.orm) then self.orm:save(self) end
	if(self:is_create()) then self:execute_filters(self.after_create) end
	self:execute_filters(self.after_save)
end

function _M:delete()
end

function _M:is_create()
	if(self.id == nil) then return true else return false end
end

function _M.create(attributes)
	-- body
end

function _M.query(params)

end

function _M.find(id)

end

function _M.delete(id)
end

local function init_filters()
	local filter_candidates = {"create", "save", "delete"}
	for _, method in ipairs(filter_candidates) do
		_M["before_" .. method] = {}
		_M["after_" .. method] = {}
	end
end

init_filters()