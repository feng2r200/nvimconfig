local config = {}

function config.nvim_treesitter()
    vim.api.nvim_command("set foldmethod=expr")
    vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")

    require("nvim-treesitter.configs").setup({
        ensure_installed = "maintained",
        highlight = { enable = true, disable = { "vim" } },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]["] = "@function.outer",
                    ["]m"] = "@class.outer",
                },
                goto_next_end = {
                    ["]]"] = "@function.outer",
                    ["]M"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                    ["[m"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                    ["[M"] = "@class.outer",
                },
            },
        },
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
        },
        context_commentstring = { enable = true, enable_autocmd = false },
        matchup = { enable = true },
        context = { enable = true, throttle = true },
    })
	require("nvim-treesitter.install").prefer_git = true
	local parsers = require("nvim-treesitter.parsers").get_parser_configs()
	for _, p in pairs(parsers) do
		p.install_info.url = p.install_info.url:gsub("https://github.com/", "git@github.com:")
	end
end

function config.nvim_gps()
    require("nvim-gps").setup({
        icons = {
            ["class-name"] = " ", -- Classes and class-like objects
            ["function-name"] = " ", -- Functions
            ["method-name"] = " ", -- Methods (functions inside class-like objects)
            ["container-name"] = '⦿ ',
            ["tag-name"] = '# '
        },
        separator = " > "
    })
end

function config.autotag()
    require("nvim-ts-autotag").setup({
        filetypes = {
            "html",
            "xml",
            "javascript",
            "typescriptreact",
            "javascriptreact",
            "vue",
        },
    })
end

function config.neoscroll()
    require("neoscroll").setup({
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = {
            "<C-u>",
            "<C-d>",
            "<C-b>",
            "<C-f>",
            "<C-y>",
            "<C-e>",
            "zt",
            "zz",
            "zb",
        },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
    })
end

function config.toggleterm()
    require("toggleterm").setup({
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.40
            end
        end,
        open_mapping = [[<C-t>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        shading_factor = "1",
        start_in_insert = true,
        insert_mappings = true,
        persist_size = false,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell
    })
end

function config.dapui()
    local dap = require("dap")
    local dapui = require("dapui")

    dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
    end

    vim.cmd([[packadd nvim-dap-virtual-text]])
    require("nvim-dap-virtual-text").setup()

    dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
            expand = { "<CR>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
        },
        sidebar = {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
        },
        tray = { elements = { "repl" }, size = 10, position = "bottom" },
        floating = {
            max_height = nil,
            max_width = nil,
            mappings = { close = { "q", "<Esc>" } },
        },
        windows = { indent = 1 },
    })
end

function config.dap()
    local dap = require("dap")

    vim.cmd([[packadd nvim-dap-virtual-text]])
    vim.cmd([[packadd nvim-lspconfig]])

    local lspconfig = require("lspconfig")

    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })

    -- local liblldb_path   = "/usr/local/opt/llvm/bin/lldb-vscode"
    -- dap.adapters.lldb = {
    --     type = "executable",
    --     command = liblldb_path,
    --     name = "lldb",
    -- }
    dap.configurations.cpp = {
        {
            name = "Launch",
            -- type = "rt_lldb",
            type = "lldb",
            request = "launch",
            program = function ()
                local workspaceRoot = lspconfig.rust_analyzer.get_root_dir()
                local workspaceName = vim.fn.fnamemodify(workspaceRoot, ":t")

                return vim.fn.input("Path to executable: ", workspaceRoot .. "/target/debug/" .. workspaceName, "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            sourceLanguages = { "rust" },
            args = {},
        },
    }
    dap.configurations.rust = dap.configurations.cpp

    dap.adapters.go = function(callback, _)
        local stdout = vim.loop.new_pipe(false)
        local handle
        local pid_or_err
        local port = 38697
        local opts = {
            stdio = { nil, stdout },
            args = { "dap", "-l", "127.0.0.1:" .. port },
            detached = true,
        }
        handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
            stdout:close()
            handle:close()
            if code ~= 0 then print("dlv exited with code", code) end
        end)
        assert(handle, "Error running dlv: " .. tostring(pid_or_err))
        stdout:read_start(function(err, chunk)
            assert(not err, err)
            if chunk then
                vim.schedule(function()
                    require("dap.repl").append(chunk)
                end)
            end
        end)
        -- Wait for delve to start
        vim.defer_fn(function()
            callback({ type = "server", host = "127.0.0.1", port = port })
        end, 100)
    end
    -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
    dap.configurations.go = {
        {
            type = "go",
            name = "Debug",
            request = "launch",
            mode = "debug",
            program = "${file}",
            -- stopOnEntry = true,
        },
        {
            type = "go",
            name = "Debug test",
            request = "launch",
            mode = "test",
            program = "${file}",
            -- stopOnEntry = true,
        },
        {
            type = "go",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
            -- stopOnEntry = true
        }
    }

    dap.adapters.python = {
        type = "executable",
        command = "python",
        args = {"-m", "debugpy.adapter"}
    }
    dap.configurations.python = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}",
            stopOnEntry = false
        }
    }
end

function config.surround()
    require("surround").setup({
        mappings_style = "surround"
    })
end

return config
