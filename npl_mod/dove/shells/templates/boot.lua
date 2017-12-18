
NPL.load("(gl)script/apps/WebServer/WebServer.lua")
NPL.load("dove/init") -- important: load dove application framework
NPL.load("app/middleware")

-- 启动web服务器
WebServer:Start("app", "0.0.0.0", _D.config.port or 8099);

-- persist pid under linux
local os = commonlib.gettable("System.os")
if(os.GetPlatform() == "linux") then
	local pid = ParaEngine.GetAttributeObject():GetField("ProcessId", 0)
	local file = assert(io.open("server.pid", "w"))
	file:write(pid)
	file:close()
end

NPL.this(function() end)