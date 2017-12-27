--[[
title: Layout for renderer
author: chenqh
date: 2017/12/26
description: render view in a layout, to keep view file simple
]]

local _M = commonlib.inherit(nil, "Dove.View.Layout")
local Renderer = commonlib.gettable("Dove.View.Renderer")
local PathHelper = commonlib.gettable("Dove.Utils.PathHelper")
local table_insert = table.insert

local function load_layout_path(template)
    local path_stack = {"app/views"}
    local template_file = APP.config.template_file or Renderer.default_template_file
    table_insert(path_stack, template .. template_file)
    return PathHelper.concat_table(path_stack)
end

function _M:ctor()
    self.template = APP.config.layout.default_template
    self.enable = APP.config.layout.enable
    self.title = APP.config.name
end

function _M:render(ctx, content)
    self.content = content
    self.path = load_layout_path(self.template)
    return Renderer.render_template(ctx, self, self.path)
end

function _M:set_template(template)
    self.template = template
end

function _M:set_title(title)
    self.title = title
end

function _M:set_enable(enable)
    self.enable = enable
end