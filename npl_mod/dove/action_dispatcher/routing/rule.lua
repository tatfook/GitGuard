
local _M = commonlib.inherit(nil, "ActionDispatcher.Routing.Rule")
local StringHelper = commonlib.gettable("Dove.Utils.StringHelper")
local RegexHelper = commonlib.gettable("ActionDispatcher.Routing.RegexHelper")
local table_concat = table.concat
local table_insert = table.insert
local deepcopy = commonlib.deepcopy

function _M:ctor()
end

function _M:init(rule)
    self.origin     = deepcopy(rule)
    self.method     = rule[1] -- "PUT"
    self.url        = rule[2] -- "/users/:id/"
    self.controller = rule[3] -- "controller.user"
    self.action     = rule[4] -- "update"
    self.desc       = rule[5]  -- "update a user"
    self.regex = RegexHelper.formulize(self.url)
    return self
end

function _M:generate_url(params)
    local url = self.url
    for key in self.url:gmatch(":%w*id") do
        local id_key = key:gsub("^:(%w*id)", "%1")
        if(not params[id_key]) then error("Invalid params on Key: " .. id_key) end
        url = url:gsub(key, params[id_key])
        params[id_key] = nil
    end
    local tails = {}
    for k, v in pairs(params or {}) do
        table_insert(tails, k .. "=" .. v)
    end
    if(#tails > 0) then
        url = url .. "?" .. table_concat(tails, "&")
    end
    return url
end

-- eg: url "/users/:user_id/projects/:id" will add extra params "id" and "user_id"
function _M:complete_extra_params(url, params)
    local extra_keys = self.url:match(":%w*id")
    if(extra_keys == nil or #extra_keys == 0) then return params end

    local rule_url_fragments = StringHelper.split(self.url, "[^/]+")
    local url_fragments = StringHelper.split(url, "[^/]+")

    for index, key in ipairs(rule_url_fragments) do
        if(key:match("^:%w*id$")) then
            key = key:gsub("^:(%w*id)$", "%1")
            params[key] = url_fragments[index]
        end
    end
    return params
end