-- ~/.config/nvim/lua/fzf-setup.lua
-- Complete fzf-lua setup for CopilotChat integration

require('fzf-lua').setup({
  -- Use fzf-native for better performance
  fzf_bin = 'fzf',
  
  -- Configure winopts for consistent UI
  winopts = {
    height = 0.85,
    width = 0.80,
    row = 0.35,
    col = 0.50,
    border = 'rounded',
    preview = {
      default = 'bat',
      border = 'border',
      wrap = 'nowrap',
      hidden = 'nohidden',
      vertical = 'down:45%',
      horizontal = 'right:60%',
      layout = 'flex',
      flip_columns = 120,
    },
  },

  -- Configure files picker (important for CopilotChat #file: context)
  files = {
    prompt = 'Files❯ ',
    multiprocess = true,           -- run command in a separate process
    git_icons = true,              -- show git icons?
    file_icons = true,             -- show file icons?
    color_icons = true,            -- colorize file|git icons
    -- path to a find executable
    find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
    rg_opts = [[--color=never --files --hidden --follow -g "!.git"]],
    fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
  },

  -- Configure other pickers
  buffers = {
    prompt = 'Buffers❯ ',
    file_icons = true,
    color_icons = true,
  },

  -- Configure grep for searching
  grep = {
    prompt = 'Rg❯ ',
    input_prompt = 'Grep For❯ ',
    multiprocess = true,
    git_icons = true,
    file_icons = true,
    color_icons = true,
  },
})

-- Optional: Add some useful keymaps for fzf-lua
local fzf = require('fzf-lua')

vim.keymap.set('n', '<leader>ff', fzf.files,     { desc = 'Find files' })   -- :Files
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep' })    -- :Rg
vim.keymap.set('n', '<leader>fb', fzf.buffers,   { desc = 'Find buffers' }) -- :Buffers
vim.keymap.set('n', '<leader>fh', fzf.help_tags, { desc = 'Help tags' })    -- :Helptags
vim.keymap.set('n', '<leader>fm', fzf.marks,     { desc = 'Find marks' })   -- :Marks
vim.keymap.set('n', '<leader>fl', fzf.lines,     { desc = 'Search lines' }) -- :Lines
vim.keymap.set('n', '<leader>fc', fzf.commands,  { desc = 'Find commands' })-- :Commands
vim.keymap.set('n', '<leader>fo', fzf.oldfiles,  { desc = 'Recent files' }) -- :History

-- Optional: keep Ex command aliases so :Buffers / :RG still work
vim.api.nvim_create_user_command("Buffers", fzf.buffers, {})
vim.api.nvim_create_user_command("Marks",   fzf.marks, {})
vim.api.nvim_create_user_command("RG",      fzf.live_grep, {})
vim.api.nvim_create_user_command("Files",   fzf.files, {})

-- Override vim.ui.select to use fzf-lua
vim.ui.select = function(items, opts, on_choice)
  require('fzf-lua').fzf_exec(items, {
    prompt = (opts.prompt or "Select one: ") .. "❯ ",
    actions = {
      ["default"] = function(selected)
        if selected and #selected > 0 then
          on_choice(selected[1], nil) -- return first selection
        else
          on_choice(nil, "No choice selected")
        end
      end
    }
  })
end
