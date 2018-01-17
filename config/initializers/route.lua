
local Route = commonlib.gettable("ActionDispatcher.Routing.Route")

local routes = {
    urls = {
        {"get", "/", "Controller.Home", "index"}
    },
    resources = {
        repositories = {},
    }
}

Route.init(routes)
