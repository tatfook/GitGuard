local _M = commonlib.gettable("Dove.Helper")
local Router = commonlib.gettable("ActionDispatcher.Routing.Router")

function _M.url_for(url, method, params)
    return Router.url_for(url, method, params)
end

function _M.route_for(url, name, options)
    local html = "<a href='" .. url .. "'"

    for k, v in pairs(options or {}) do
        html = html .. " " .. k .. " = " .. v
    end

    html = html .. ">" .. name .. "</a>"
    return html
end