local config = {}

function config.leetcode()
    if not packer_plugins['leetcode.vim'].loaded then
        vim.cmd [[packadd leetcode.vim]]
    end
    vim.api.nvim_set_var('leetcode_browser', 'chrome')
    vim.api.nvim_set_var('leetcode_solution_filetype', 'java')
end

return config
