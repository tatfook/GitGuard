--[[
    Title:  repository model
    Author: chenqh
    Date:   2017/11/22
    Desc:   repository CRUD and some extra complicated database operations
]]

local _M = commonlib.inherit(Dove.Model.Base, 'Model.Repository')
_M.db_name = "repository"

_M.before_create = {"init_repository"}

function _M:ctor()
    self:add_attributes({
        {name = "name", type = "string", default = ""},
        {name = "desc", type = "string", default = ""}
    })
end

function _M:init_repository()
    self.repo = GIT.Repository.init(APP.config.git_path .. self.data.name, 1)
    self:print_repo()
end

function _M:print_repo()
    print("----------------------------------------------")
    print("Repository Path: " .. self.repo:path())
    if(self.repo:workdir()) then print("Repositoru workdir: " .. self.repo:workdir()) end
    print("----------------------------------------------")
end