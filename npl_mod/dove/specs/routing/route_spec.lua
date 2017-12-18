--[[
title: test route
author: chenqh
date: 2017/12/11
]]

NPL.load("dove/specs/spec_helper")

local Route = commonlib.gettable("Dove.Routing.Route")

local routes = {
    urls = {
        {"get", "/", "controller.user", "home"} -- {method, url, controller, action, desc}
    },
    rules = {
        {"get", "^/profile/%w*$", "controller.profiles", "show"}
    },
    namespaces = {
        admin = {
            resources = {
                users = {
                    except = {"delete"},
                    members = {
                        {"post", "change_password"}
                    }
                }
            }
        },
        user = {
            resources = {
                profiles = {
                    only = {"show", "update", "edit"}
                }
            }
        }
    },
    resources = {
        users = {
            only = {},
            collections = {
                {"post", "sign_up"},
                {"post", "sign_in"},
                {"delete", "sign_out"}
            }
        }
    }
}

local function test_print()
    Route.init(routes)
    Route.print()
end

local function test_api_only()
    Route.set_api_only(true)
    Route.init(routes)
    Route.print()
end

test_print()
print("---------------------------------------------------------------")
test_api_only()
