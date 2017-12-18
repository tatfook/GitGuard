--[[
title: initializer
author: chenqh
date: 2017/12/11
desc: load dove libraries in order
]]

NPL.load("./utils/utils")
NPL.load("./middleware/base")
NPL.load("./controller/base")
NPL.load("./model/base")
NPL.load("./action_dispatcher/processor")

NPL.load("./config")
NPL.load("./context")
NPL.load("./application")

print("app framework is ready")
