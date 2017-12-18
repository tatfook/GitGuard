--[[
title: initializer
author: chenqh
date: 2017/12/11
desc: load dove libraries in order
]]

NPL.load("./config")
NPL.load("./utils/utils")
NPL.load("./middleware/base")
NPL.load("./controller/base")
NPL.load("./model/base")
NPL.load("./action_dispatcher/processor")

local Loader = commonlib.gettable("Dove.Utils.Loader")

Loader.load_files("app/controllers")
Loader.load_files("app/models")
Loader.load_files("config/initializers")

print("app framework is ready")
