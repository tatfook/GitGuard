--[[
title:  route manager
author: chenqh
date:   2017/11/22
desc:   Load the route config and manage it globally
example
------------------------------------------------------
router.parse(request)

GET /users
=> route.users.index
=> commonlib.gettable("controller.user").index
GET /users/:id
=> route.users.show
=> commonlib.gettable("controller.user").show -- params[:id] = :id
POST /users/
=> route.users.create
=> commonlib.gettable("controller.user").create
PUT /users/:id
=> route.users.update
=> commonlib.gettable("controller.user").update
DELETE /users/:id
=> route.users.delete
=> commonlib.gettable("controller.user").delete
GET /users/:id/pages
=> try route.users.members.pages.index
=> commonlib.gettable("controller.page").index -- params[:user_id] = :id
=> or route.users.actions.pages
=> commonlib.gettable("controller.user").pages -- params[:id] = :id
POST /users/add_pages
=> try route.users.add_pages
=> commonlib.gettable("controller.user").add_pages
GET /user/pages
=> route.users.collections.pages.index
=> commonlib.gettable("controller.user.page").index
]]

local Pluralize = commonlib.gettable("Dove.Utils.Pluralize")
local StringHelper = commonlib.gettable("Dove.Utils.StringHelper")
local RegexHelper = commonlib.gettable("ActionDispatcher.Routing.RegexHelper")
local _M = commonlib.gettable("ActionDispatcher.Routing.Route")

local route_matcher = {
    get         = "show",
    post        = "create",
    delete      = "delete",
    put         = "update"
}

local is_plural = Pluralize.is_plural
local singular = Pluralize.singular
local plural = Pluralize.plural
local table_concat = table.concat
local table_insert = table.insert
local table_clone = table.clone
local deepcopy = commonlib.deepcopy

_M.routes = {}
_M.rules = {}
_M.api_only = false -- the default restful actions will not include :new and :edit if api only

local function url_tail(action, is_member)
    if(action == "index" or action == "create") then return "" end
    if(action == "show" or action == "delete" or action == "update") then return "/:id" end
    if(action == "edit" or is_member == true) then return "/:id/" .. action end
    if(action == "new" or is_member == false) then return "/" .. action end
    error("Invalid action setting: " .. action)
end

local function build_url_and_controller(action, resource, resources_stack, namespaces, is_member)
    local controller = "Controller"
    local url = ""
    if(namespaces ~= nil) then
        controller = controller .. "." .. namespaces.concat(".")
        url = "/" .. namespaces.concat("/")
    end

    controller = controller .. "." .. singular(resource)
    if(resources_stack ~= nil) then
        for _, r in ipairs(resources_stack) do
            url = url .. "/" .. plural(r) .. "/:" .. singular(r) .. "_id" -- r is the parent resource
        end
    end
    url = url .. "/" .. plural(resource:lower())
    url = url .. url_tail(action, is_member)

    return url, controller
end

local function build_rest_actions(only, except, resource, resources_stack, namespaces)
    -- defalt actions
    local actions_map = {
        index   = "get", -- action = method
        show    = "get",
        new     = "get",
        create  = "post",
        edit    = "get",
        update  = "put",
        delete  = "delete",
    }
    if(_M.api_only) then
        actions_map.new = nil
        actions_map.edit = nil
    end

    if(only ~= nil) then
        if(next(only) == nil) then return {} end
        for k, _ in pairs(actions_map) do
            for _, v in pairs(only) do
                if(k ~= v) then
                    actions_map[k] = nil
                end
            end
        end
    end
    if(except ~= nil) then -- remove the except
        for _, v in pairs(except) do
            actions_map[v] = nil
        end
    end

    local result = {}
    local url = nil
    local method = nil
    local controller = nil
    for action, method in pairs(actions_map) do
        url, controller = build_url_and_controller(action, resource, resources_stack, namespaces)
        method = actions_map[action]
        _M.add_rule({method, url, controller, action})
    end
end

local function build_resources(r_list, namespaces, resources_stack)
    for resource, node in pairs(r_list or {}) do
        resource = StringHelper.capitalize(resource)
        build_rest_actions(node.only, node.except, resource, namespaces, resources_stack)

        if(node.members ~= nil) then -- add the members
            for _, member in ipairs(node.members) do
                local method = member[1]
                local action = member[2]
                local url, controller = build_url_and_controller(action, resource, resources_stack, namespaces, true)
                _M.add_rule({method, url, controller, action})
            end
        end

        if(node.collections ~= nil) then -- add the collections
            for _, collection in ipairs(node.collections) do
                local method = collection[1]
                local action = collection[2]
                local url, controller = build_url_and_controller(action, resource, resources_stack, namespaces, false)
                _M.add_rule({method, url, controller, action})
            end
        end

        if(node.resources ~= nil) then -- build nested resources
            resources_stack = resources_stack or {}
            table_insert(resources_stack, resource:lower())
            build_namespaces(node.resources, namespaces, resources_stack)
        end
    end
end

local function build_namespaces(n_list, namespaces)
    for namespace, node in pairs(n_list or {}) do
        if(node.namespaces ~= nil) then
            namespaces = namespaces or {}
            build_namespaces(node.namespaces, table_insert(namespaces, namespace))
        end
        if(node.resources ~= nil) then build_resources(node.resources, namespaces) end
    end
end

local function build_urls(urls)
    for _, rule in ipairs(urls or {}) do
        _M.add_rule(rule)
    end
end

local function build_rules(rules)
    for _, rule in ipairs(rules or {}) do
        _M.add_rule(rule)
    end
end

function _M.add_rule(rule)
    local rule_object = {
        origin      = deepcopy(rule),
        method      = rule[1], -- "PUT"
        url         = rule[2], -- "/users/:id/"
        controller  = rule[3], -- "controller.user"
        action      = rule[4], -- "update"
        desc        = rule[5],  -- "update a user"
    }
    rule_object.regex = RegexHelper.formulize(rule_object.url)
    table_insert(_M.rules, rule_object)
end

function _M.init(source)
    _M.routes = {} -- recreate
    build_urls(source.urls)
    build_namespaces(source.namespaces)
    build_resources(source.resources)
    build_rules(source.rules)
end

function _M.set_api_only(config_value)
    _M.api_only = not(not(config_value))
end

function _M.print()
    for _, rule in ipairs(_M.rules) do
        log(table_concat(rule.origin, "  ") .. "  " .. rule.regex .. "\n")
    end
end

function _M.parse(method, url)
    for _, r in ipairs(_M.rules) do
        if(r.method == method:lower() and url:match(r.regex)) then
            return deepcopy(r) -- keep route rules save
        end
    end
    error("Invalid url: " .. url)
end