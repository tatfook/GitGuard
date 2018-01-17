--[[
    Title:  repository model
    Author: chenqh
    Date:   2017/11/22
    Desc:   repository CRUD and some extra complicated database operations
]]
local _M = commonlib.inherit(Dove.Model.Base, "Model.Repository")
local lfs = commonlib.Files.GetLuaFileSystem()
local PathHelper = commonlib.gettable("Dove.Utils.PathHelper")

_M.db_name = "repository"

_M.before_create = {"init_repository"}

function _M:ctor()
    self:add_attributes(
        {
            {name = "name", type = "string", default = ""},
            {name = "desc", type = "string", default = ""}
        }
    )
end

function _M:init(name)
    self.name = name
    return self
end

function _M:path()
    return PathHelper.concat(APP.config.git_path, self.name)
end

function _M:open()
    self.repo = GIT.Repository.open(self:path())
    self:print_repo()
end

function _M:init_repository()
    self.repo = GIT.Repository.init(self:path(), 1)
    self:print_repo()
end

function _M:print_repo()
    print("----------------------------------------------")
    print("Repository Path: " .. self.repo:path())
    if (self.repo:workdir()) then
        print("Repositoru workdir: " .. self.repo:workdir())
    end
    print("----------------------------------------------")
end

-- list all repositories in current Git server
function _M.list_all()
    local repository_list = {}
    local basedir = APP.config.git_path
    for entry in lfs.dir(basedir) do
        if entry ~= "." and entry ~= ".." then
            local path = PathHelper.concat(basedir, entry)
            local attr = lfs.attributes(path)
            if (not (type(attr) == "table")) then
                error("get attributes of '" .. path .. "' failed.")
            end
            if attr.mode == "directory" then
                table.insert(repository_list, entry)
            end
        end
    end
    return repository_list
end
