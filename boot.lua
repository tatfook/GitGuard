NPL.load("(gl)script/apps/WebServer/WebServer.lua")
NPL.load("./config/application")

-- nplc start
return function(ctx)
    APP = Application:new()
    APP.config.env = ctx.env or "development"
    APP.config.port = ctx.port or 8088
    APP:start()
end
