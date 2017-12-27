local _M = commonlib.gettable("Dove.View.Helper")
local Route = commonlib.gettable("ActionDispatcher.Routing.Route")

--TODO
function _M.url_for(url, method, params)
    if(type(url) ~= "string") then error("invalid path") end
    local rule = Route.find_rule(url, method, params)
    if(not rule) then error("Invalid params to generate url") end
    return rule:generate_url(params)
end

function _M.route_for(url, name, options)
    local html = "<a href='" .. url .. "'"

    for k, v in pairs(options or {}) do
        html = html .. " " .. k .. " = " .. v
    end

    html = html .. ">" .. name .. "</a>"
    return html
end