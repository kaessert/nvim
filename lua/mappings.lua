require "nvchad.mappings"

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

-- quick quit
vim.keymap.set('n', '<leader>X', '<cmd>qa!<CR>', {desc = 'Quick quit'})


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

-- Set keybindings if platformio.ini exists
if is_zephyr_project() then
    vim.keymap.set('n', '<leader>B', '<cmd>!west build -p auto .<CR>', { noremap = true })
    vim.keymap.set('n', '<leader>U', '<cmd>!west flash --runner jlink<CR>', { noremap = true })
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

local function run_in_term(cmd)
    -- Create a new split window at the bottom
    vim.cmd('botright new')
    -- Set buffer options for terminal
    vim.bo.buftype = 'nofile'
    vim.bo.bufhidden = 'hide'
    -- Run the command in terminal
    vim.fn.termopen(cmd, {
        on_exit = function(_, exit_code)
--            if exit_code == 0 then
--                -- Optionally close the terminal window after successful execution
--                vim.defer_fn(function()
--                    vim.cmd('quit')
--                end, 2000) -- Wait 2 seconds before closing
--            end
        end
    })
    -- Enter insert mode to allow interaction if needed
    vim.cmd('startinsert')
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

-- Function to find the first real buffer window
--local function jump_to_last_buffer()
--    -- Get list of windows
--    local wins = vim.api.nvim_list_wins()
--    -- Find last accessed window that isn't NvimTree or terminal
--    for _, win in ipairs(wins) do
--        local buf = vim.api.nvim_win_get_buf(win)
--        local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
--        local buf_name = vim.api.nvim_buf_get_name(buf)
--        if buf_type ~= 'terminal' 
--            and buf_type ~= 'nofile'
--            and not buf_name:match('NvimTree') then
--            vim.api.nvim_set_current_win(win)
--            return
--        end
--    end
--end
--
---- Set up autocmd for any buffer close
--vim.api.nvim_create_autocmd({'BufLeave', 'WinClosed'}, {
--    callback = function(ev)
--        -- Get the buffer that's being left
--        local buf = ev.buf
--        local buf_type = vim.api.nvim_buf_get_option(buf, 'buftype')
--        local buf_name = vim.api.nvim_buf_get_name(buf)
--        -- If it's a special buffer (like NvimTree or terminal)
--        if buf_type == 'terminal' 
--            or buf_type == 'nofile'
--            or buf_name:match('NvimTree') then
--            -- Schedule the jump to prevent interfering with the buffer closing
--            vim.schedule(function()
--                jump_to_last_buffer()
--            end)
--        end
--    end
--})

--local autocmd = vim.api.nvim_create_autocmd
--
--autocmd("FileType", {
--   pattern = "*",
--   callback = function()
--      require("cmp").setup.buffer { enabled = false }
--   end,
--})
--
--vim.filetype.add({
--    extension = {
--        k = "kcl",
--    },
--})
--
vim.opt.tabstop = 4      -- Number of spaces a <Tab> counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for autoindent
vim.opt.expandtab = true   -- Use spaces instead of tabstop

