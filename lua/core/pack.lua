local uv, api = vim.loop, vim.api

local data_dir = vim.fn.stdpath("data") .. "/site"
local packer_compiled = data_dir .. "/lua/_compiled.lua"
local bak_compiled = data_dir .. "/lua/bak_compiled.lua"

local packer = nil

local Packer = {}
Packer.__index = Packer

function Packer:load_plugins()
    self.repos = {}

    local repos = require("core.plugins")
    for repo, conf in pairs(repos) do
        self.repos[#self.repos + 1] = vim.tbl_extend("force", {repo}, conf)
    end
end

function Packer:load_packer()
    if not packer then
        api.nvim_command("packadd packer.nvim")
        packer = require("packer")
    end
    packer.init({
        compile_path = packer_compiled,
        git = { clone_timeout = 120 },
        disable_commands = true,
        max_jobs = 20,
        display = {
            open_fn = function()
                return require("packer.util").float({ border = "single" })
            end,
        },
    })
    packer.reset()
    local use = packer.use
    self:load_plugins()
    use {"wbthomason/packer.nvim", opt = true}
    for _, repo in ipairs(self.repos) do use(repo) end
end

function Packer:init_ensure_plugins()
    local packer_dir = data_dir .. "/pack/packer/opt/packer.nvim"
    local state = uv.fs_stat(packer_dir)
    if not state then
        local cmd = "!git clone https://github.com/wbthomason/packer.nvim --depth=1 " .. packer_dir
        api.nvim_command(cmd)
        uv.fs_mkdir(data_dir .. "/lua", 511, function() assert("make compile path dir faield") end)
        self:load_packer()
        packer.install()
    end
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        if not packer then Packer:load_packer() end
        return packer[key]
    end
})

function plugins.ensure_plugins() Packer:init_ensure_plugins() end

function plugins.back_compile()
	if vim.fn.filereadable(packer_compiled) == 1 then
		os.rename(packer_compiled, bak_compiled)
	end
    plugins.compile()
end

function plugins.load_compile()
    if vim.fn.filereadable(packer_compiled) == 1 then
        require("_compiled")
    else
        assert("Missing packer compile file Run PackerCompile Or PackerInstall to fix")
    end
    vim.cmd([[command! PackerCompile lua require('core.pack').back_compile()]])
    vim.cmd([[command! PackerInstall lua require('core.pack').install()]])
    vim.cmd([[command! PackerUpdate lua require('core.pack').update()]])
    vim.cmd([[command! PackerSync lua require('core.pack').sync()]])
    vim.cmd([[command! PackerClean lua require('core.pack').clean()]])
    vim.cmd([[autocmd User PackerComplete lua require('core.pack').back_compile()]])
    vim.cmd([[command! PackerStatus lua require('core.pack').compile() require('packer').status()]])
end

return plugins
