require "nvchad.options"

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Get the filename or directory passed to vim
    local arg = vim.fn.argv(0)

    -- Check if no argument was passed or if it's a directory
    if arg == "" or (arg ~= nil and vim.fn.isdirectory(arg) == 1) then
      -- Use vim.schedule to ensure nvim-tree is loaded
      vim.schedule(function()
        require("nvim-tree.api").tree.focus()
      end)
    end
  end,
})

vim.filetype.add({
    extension = {
        k = "kcl",
    },
})

-- require("nvim-autopairs").disable()
