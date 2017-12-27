--[[
    Title:  repository controller
    Author: chenqh
    Date:   2017/11/22
    Desc:   repository CRUD API Method
]]

local _C = commonlib.inherit(Dove.Controller.Base, "Controller.Repository")
_C.resource_name = "repository"

_C.before_each("print_params")

function _C:print_params()
    for k, v in pairs(self.params) do
        print(k .. " ------ " .. v)
    end
end

function _C:index()
    local list = Model.Repository.list_all()

    return {repositories = list}
end

function _C:show()
    print(self.params["id"])
    local repo = self.Resource:new():init(self.params["id"])
    repo:open()

    return {repo = repo}
end

function _C:add()
    self:redirect_to("Repository#index", "get")
end

function _C:create()
    print("==============================create repository")
    local repo = self.Resource:new():build(self.params)
    repo:save()
    -- render(repo.data)
end