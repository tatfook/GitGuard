-- Please install libgit2 0.17.0 first

GIT = require("git2") -- add git2 to global
if(type(GIT) == "table") then
    print("Load: luagit2")
end
