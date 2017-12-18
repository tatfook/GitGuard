
local Route = commonlib.gettable("ActionDispatcher.Routing.Route")

local routes = {
    urls = {
        {"get", "/", "controller.repository", "index"}
    },
    resources = {
        repositories = {},
    }
}

Route.init(routes)
Route.print()
