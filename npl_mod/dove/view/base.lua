NPL.load("./helper")
NPL.load("./layout")
NPL.load("./renderer")

local _M = commonlib.inherit(nil, "Dove.View.Base")
local Renderer = commonlib.gettable("Dove.View.Renderer")
local Layout = commonlib.gettable("Dove.View.Layout")
local Pluralize = commonlib.gettable("Dove.Utils.Pluralize")
local PathHelper = commonlib.gettable("Dove.Utils.PathHelper")
local table_insert = table.insert

local function load_view_path(ctx)
    local path_stack = {"app/views"}
    local base_path = ctx.rule.controller:lower():gsub("^controller.", "")

    for path in base_path:gmatch("%w+") do
        table_insert(path_stack, path)
    end

    path_stack[#path_stack] = Pluralize.plural(path_stack[#path_stack])

    local template_file = APP.config.template_file or Renderer.default_template_file
    table_insert(path_stack, ctx.rule.action .. template_file)

    return PathHelper.concat_table(path_stack)
end

function _M:ctor()
end

function _M:init(ctx)
    self.ctx = ctx
    self.layout = Layout:new()
    return self
end

function _M:render()
    if(self.is_rendered) then return end
    self.path = load_view_path(self.ctx)

    if(self.ctx.request:IsJsonBody()) then
        self.ctx.response:sendsome(Renderer.render_json(view))
    else
        local content = Renderer.render_template(self.ctx, self.data, self.path)
        if(self.layout.enable) then
            content = self.layout:render(self.ctx, content)
        end
        self.ctx.response:set_header('Content-Type', 'text/html;charset=utf-8')
        self.ctx.response:sendsome(content)
    end
    self.is_rendered = true
end

function _M:set_layout(layout_name)
    self.layout:set_layout(layout_name)
end