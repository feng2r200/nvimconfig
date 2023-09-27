-- https://github.com/Microsoft/vscode-cpptools

local configurations = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            local source_path = vim.fn.expand("%:p")
            local execute_path = vim.fn.expand("%:p:r")
            local command = ("gcc -fdiagnostics-color=always -g %s -o %s"):format(
                source_path,
                execute_path
            )
            vim.fn.jobstart(command)
            return execute_path
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
    },
}

return {
    adapters = {
        cppdbg = {
            id = "cppdbg",
            type = "executable",
            -- Linux
            command = "OpenDebugAD7",
        },
    },
    configurations = {
        c = vim.deepcopy(configurations),
        cpp = vim.deepcopy(configurations),
    },
}
