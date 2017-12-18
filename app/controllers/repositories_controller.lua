--[[
    Title:  repository controller
    Author: chenqh
    Date:   2017/11/22
    Desc:   repository CRUD API Method
]]

local _C = commonlib.inherit(Dove.Controller.Base, "Controller.Repository")
_C.resource_name = "repository"

_C.before_filters = {
    index = {"say_hello"}
}

function _C:say_hello()
    print("========================say hello!")
end

function _C:index()
    echo("I'm here!")
    self.response:send("Hello World!", true)
end

function _C:create()
    print("==============================create repository")
    for k, v in pairs(self.params) do
        print(k .. " ------ " .. v)
    end
    local repo = self.Resource:new():build(self.params)
    repo:save()
    -- render(repo.data)
end