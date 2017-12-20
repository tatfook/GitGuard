
--[[
Title: base class of all controllers
Author: Chenqh
Date: 2017/11/22
Desc: model converts from database rows to objects.
virtual functions: index, show, create, destroy, update
]]
NPL.load("./filter")

local _M = commonlib.inherit(nil, "Dove.Controller.Base")
local Renderer = commonlib.gettable("Dove.Renderer")

_M.resource_name = "unnamed"

local table_insert = table.insert

function _M:ctor()
end

function _M:init(ctx)
    self.ctx = ctx
    self.params = ctx.params
    self.request = ctx.request
    self.response = ctx.response

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
    self:execute_with_filters(action)
    if(not self.ctx.is_render and not self.is_redirect) then self:render() end -- will try to render default data
end

function _M:render()
    Renderer.render(self.ctx)
end

function _M:redirect_to(uri)
    self.is_redirect = true
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
