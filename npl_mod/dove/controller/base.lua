
--[[
Title: base class of all controllers
Author: Chenqh
Date: 2017/11/22
Desc: model converts from database rows to objects.
virtual functions: index, show, create, destroy, update
]]
NPL.load("./module/filter")

local _M = commonlib.inherit(nil, "Dove.Controller.Base")
local View = commonlib.gettable("Dove.View.Base")

_M.resource_name = "unnamed"

local table_insert = table.insert

function _M:ctor()
end

function _M:init(ctx)
    self.ctx = ctx
    self.params = ctx.params
    self.request = ctx.request
    self.response = ctx.response
    self.view = View:new():init(ctx)

    self.have_resource = true
    if(self.resource_name == "unnamed") then
        self.have_resource = false
        return self
    end
    self.Resource = commonlib.gettable("Model." .. Dove.Utils.StringHelper.classify(self.resource_name))
    if(self.Resource == nil) then
        error("invalid resource name: " .. self.resource_name)
    end
    return self
end

function _M:handle(action)
    self:execute_with_filters(action)
    if(not self.view.is_rendered and not self.is_redirected) then self.view:render() end
end

function _M:redirect_to(uri)
    self.is_redirected = true
    -- TODO
end

function _M:index()
    if(self.have_resource) then
        return self.resource.get(self.params)
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

Dove.Module.import(_M, "Module.Controller.Filter")
