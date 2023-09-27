-- https://github.com/akinsho/bufferline.nvim

local api = require("utils.api")

local M = {}

M.lazy = {
    "akinsho/bufferline.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event = { "UIEnter" },
}

function M.init()
    M.bufferline = require("bufferline")
end

function M.load()
    local icons = api.get_setting().get_icon_groups("diagnostic", true)

    M.bufferline.setup({
        options = {
            themable = true,
            show_close_icon = true,
            -- ordinal
            numbers = "none",
            buffer_close_icon = "",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            diagnostics = "nvim_lsp",
            separator_style = "thin",
            -- separator_style = { "▏", "▕" },
            -- separator_style = { "", "" },
            indicator = { icon = "▎", style = "icon" },
            ---@diagnostic disable-next-line: unused-local
            diagnostics_indicator = function(
                count,
                level,
                diagnostics_dict,
                context
            )
                if diagnostics_dict.error then
                    return ("%s%s"):format(icons.Error, diagnostics_dict.error)
                end
                if diagnostics_dict.warning then
                    return ("%s%s"):format(icons.Warn, diagnostics_dict.warning)
                end
                if diagnostics_dict.info then
                    return ("%s%s"):format(icons.Info, diagnostics_dict.info)
                end
                if diagnostics_dict.hint then
                    return ("%s%s"):format(icons.Hint, diagnostics_dict.hint)
                end
                return ""
            end,
            offsets = {
                {
                    filetype = "NvimTree",
                    text = "File Explorer",
                    highlight = "Directory",
                    text_align = "center",
                },
            },
        },
    })
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<c-q>",
            rhs = "<cmd>BufferDelete<cr>",
            options = { silent = true },
            description = "Close current buffer",
        },
        {

            mode = { "n" },
            lhs = "<leader>bq",
            rhs = "<cmd>BufferLinePickClose<cr>",
            options = { silent = true },
            description = "Close target buffer",
        },
        {
            mode = { "n" },
            lhs = "<c-h>",
            rhs = "<cmd>BufferLineCyclePrev<cr>",
            options = { silent = true },
            description = "Go to left buffer",
        },
        {
            mode = { "n" },
            lhs = "<c-l>",
            rhs = "<cmd>BufferLineCycleNext<cr>",
            options = { silent = true },
            description = "Go to right buffer",
        },
        {
            mode = { "n" },
            lhs = "<c-e>",
            rhs = "<cmd>BufferLineMovePrev<cr>",
            options = { silent = true },
            description = "Move current buffer to left",
        },
        {
            mode = { "n" },
            lhs = "<c-y>",
            rhs = "<cmd>BufferLineMoveNext<cr>",
            options = { silent = true },
            description = "Move current buffer to right",
        },
        {
            mode = { "n" },
            lhs = "<leader>bn",
            rhs = "<cmd>enew<cr>",
            options = { silent = true },
            description = "Create new buffer",
        },
        {
            mode = { "n" },
            lhs = "<leader>bh",
            rhs = "<cmd>BufferLineCloseLeft<cr>",
            options = { silent = true },
            description = "Close all left buffers",
        },
        {
            mode = { "n" },
            lhs = "<leader>bl",
            rhs = "<cmd>BufferLineCloseRight<cr>",
            options = { silent = true },
            description = "Close all right buffers",
        },
        {
            mode = { "n" },
            lhs = "<leader>bo",
            rhs = "<cmd>BufferLineCloseOthers<cr>",
            options = { silent = true },
            description = "Close all other buffers",
        },
        {
            mode = { "n" },
            lhs = "<leader>ba",
            rhs = function()
                vim.cmd("BufferLineCloseOthers")
                vim.cmd("BufferDelete")
            end,
            options = { silent = true },
            description = "Close all buffers",
        },
        {
            mode = { "n" },
            lhs = "<leader>bt",
            rhs = "<cmd>BufferLinePick<cr>",
            options = { silent = true },
            description = "Go to buffer *",
        },
        {
            mode = { "n" },
            lhs = "<leader>bs",
            rhs = "<cmd>BufferLineSortByExtension<cr>",
            options = { silent = true },
            description = "Buffers sort (by extension)",
        },
    })
end

return M

