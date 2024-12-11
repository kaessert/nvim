require "nvchad.mappings"

local function run_in_term(cmd)
    -- Create a new split window at the bottom
    vim.cmd('botright new')
    -- Set buffer options for terminal
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'hide'

    -- Create buffer-local mapping for Enter key
    vim.keymap.set('n', '<CR>', function()
        vim.cmd('quit')
        vim.keymap.del('n', '<CR>')
    end, { buffer = term_buf, silent = true })

    -- Create autocmd for when this specific terminal buffer is closed
    vim.api.nvim_create_autocmd("BufWinLeave", {
        buffer = term_buf,
        callback = function()
            vim.api.nvim_set_current_buf(1)
            vim.api.nvim_input('<C-l>')
        end,
        once = true  -- Only trigger once
    })
    -- Run the command in terminal
    vim.fn.termopen(cmd, {
        on_exit = function(_, exit_code)
            vim.api.nvim_input('<C-\\><C-n>')
        end
    })
    -- Enter insert mode to allow interaction if needed
    vim.cmd('startinsert')
end

-- Create a highlight group for trailing whitespace
vim.api.nvim_command('highlight TrailingWhitespace guibg=#404040 ctermbg=237')

-- Enable highlighting for all files
vim.api.nvim_create_autocmd({ "BufWritePost", "BufWinEnter" }, {
    pattern = "*",
    callback = function()
        vim.fn.matchadd('TrailingWhitespace', '\\s\\+$')
    end,
})

-- Create a function that will be executed when the command is called
local function remove_trailing_whitespace()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, cursor_pos)
    vim.notify("Trailing whitespace removed", vim.log.levels.INFO)
end

-- Create the custom command
vim.api.nvim_create_user_command(
    'Rtw',                              -- Command name
    remove_trailing_whitespace,         -- Function to execute
    {                                   -- Command attributes (optional)
        desc = "Remove trailing whitespace",
        bang = false,                   -- If true, the command can use !
        nargs = 0,                      -- Number of arguments (0 for none)
    }
)

-- find stuff
vim.keymap.set('n', '<C-p>', '<cmd>Telescope find_files<CR>', {desc = 'Fine File'})
vim.keymap.set('n', '<leader>F', '<cmd>Telescope live_grep<CR>', {desc = 'Grep'})

-- platformio

-- Check if platformio.ini exists in the current working directory
local function is_platformio_project()
    local platformio_ini = vim.fn.getcwd() .. "/platformio.ini"
    return vim.fn.filereadable(platformio_ini) == 1
end
--
-- Set keybindings if platformio.ini exists
if is_platformio_project() then
    vim.keymap.set('n', '<leader>B', '<cmd>!platformio run<CR>', { noremap = true })
    vim.keymap.set('n', '<leader>U', '<cmd>!platformio run -t upload<CR>', { noremap = true })
    vim.keymap.set('n', '<leader>C', '<cmd>!platformio run -t menuconfig<CR>', { noremap = true })
end

-- Check if zephyr.ini exists in the current working directory
local function is_zephyr_project()
    local prj_conf = vim.fn.getcwd() .. "/prj.conf"
    return vim.fn.filereadable(prj_conf) == 1
end

    vim.keymap.set('n', '<leader>B', function()
        run_in_term('up project build')
    end, { noremap = true })

-- Set keybindings if platformio.ini exists
if is_zephyr_project() then
    vim.keymap.set('n', '<leader>B', function()
        run_in_term('west build -p auto .')
    end, { noremap = true })
    vim.keymap.set('n', '<leader>U', function()
        run_in_term('west flash')
    end, { noremap = true })
end

vim.api.nvim_create_autocmd("FileType", {
   pattern = "kcl",
   callback = function()
      vim.keymap.set('n', '<leader>M', '<cmd>!kcl fmt %<CR>e %<CR>', { noremap = true, silent = true  })
   end,
})


-- Check if platformio.ini exists in the current working directory
local function is_upbound_project()
    local upbound_yaml = vim.fn.getcwd() .. "/upbound.yaml"
    return vim.fn.filereadable(upbound_yaml) == 1
end

if is_upbound_project() then
    vim.keymap.set('n', '<leader>B', function()
        run_in_term('up project build')
    end, { noremap = true })
    vim.keymap.set('n', '<leader>U', function()
        run_in_term('up project run')
    end, { noremap = true })
end


-- Function to create a terminal window for interactive use
local function open_terminal()
    -- Create a new split window at the bottom, 15 lines height
    vim.cmd('botright 15new')
    -- Start terminal in current directory
    vim.fn.termopen(vim.o.shell)
    -- Enter insert mode to start typing
    vim.cmd('startinsert')
end

-- Map it to <leader>t (adjust the shortcut as you prefer)
vim.keymap.set('n', '<leader>T', open_terminal, { noremap = true, desc = 'Open terminal' })

-- Optional: Add a command to open terminal
vim.api.nvim_create_user_command('Term', open_terminal, {})

vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = 'kcl',
    callback = function()
        vim.cmd('e %')
    end
})

vim.opt.tabstop = 4      -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for autoindent
vim.opt.expandtab = true   -- Use spaces instead of tabstop

