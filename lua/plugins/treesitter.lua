---@diagnostic disable: undefined-global, inject-field
-- Plugins: Tree-sitter and Syntax

return {

	-----------------------------------------------------------------------------
	-- Automatically add closing tags for HTML and JSX
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/treesitter.lua
	{
		'nvim-ts-autotag',
		event = 'InsertEnter',
	},

	-----------------------------------------------------------------------------
	-- Treesitter configurations and abstraction layer for faster and more
	-- accurate syntax highlighting.
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/treesitter.lua
	{
		'nvim-treesitter',
		dependencies = {
			-- Modern matchit and matchparen
			{
				'andymass/vim-matchup',
				init = function()
					vim.g.matchup_matchparen_offscreen = {}
				end,
			},
		},
		config = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
			end
			require('nvim-treesitter.config').setup(opts)
		end,
		opts = {
			highlight = {
				enable = true,
				disable = function(_, buf)
					local max_filesize = 1024 * 1024 -- 1MB
					local ok, stats =
						pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,
			},
			indent = { enable = true },
			refactor = {
				highlight_definitions = { enable = true },
				highlight_current_scope = { enable = true },
			},
			-- See: https://github.com/andymass/vim-matchup
			matchup = {
				enable = true,
				include_match_words = true,
			},
			incremental_selection = {
				enable = false
			},
			textobjects = {
				move = {
					enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
				},
			},
			ensure_installed = {
				"bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
				"tmux",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
			},
		},
	},
}
