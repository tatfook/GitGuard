--[[
title: a tool to count the time cost
author: chenqh
date: 2017/12/10
desc:
example:
------------------------------------------
local Benchmark = commonlib.gettable("Dove.Utils.Benchmark")
local demo_benchmark = Benchmark:new("benchmark for demo")
domo_benchmark:start()
-- do something
demo_benchmark:stop() -- will print the time cost
]]

local _M = commonlib.gettable("Dove.Utils.Benchmark")

function _M:ctor(title)
    self.title = title or "Benchmark"
    self:start()
end

function _M:start()
    if(self.started == true) then log("Benchmark was in progress, will try to restart it!") end
    self.start = os.clock()
    self.started = true
    self.stop = nil
    self.time_cost = nil
end

function _M:stop()
    if(self.started ~= true) then
        log("Benchmark is disabled, please start it first!")
        return
    end
    self.stop = os.clock()
    self.time_cost = self.stop - self.start
    self:print()
end

function _M:print()
    if(self.started == true) then
        log("Benchmark is in progress, please stop it first!")
        return
    end
    log(format("## Benchmark ## %s cost %s", self.title, self.time_cost ))
end

