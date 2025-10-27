require("CopilotChat").setup({
    auto_insert_mode = true,
    chat_autocomplete = true,
    show_help = false,
    show_folds = false,
    
    -- Improved window configuration
    window = {
        split = "vertical",
        size = 50,
    },
    
    -- Fixed mappings (your close mapping was missing angle brackets)
    mappings = {
        complete = { insert = "<C-l>" },  -- Fixed: was "accept", should be "complete"
        close = { 
            insert = "<C-q>",  -- Fixed: added angle brackets
            normal = "q"       -- Added normal mode close
        },
        reset = {
            insert = "<C-r>",
            normal = "<C-l>"   -- Clear chat in normal mode
        },
        submit_prompt = {
            insert = "<C-s>",  -- Submit with Ctrl+S
            normal = "<CR>"    -- Submit with Enter in normal mode
        },
    },
    
    -- Better selection function
    selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.buffer(source)
    end,
    
    -- Better display settings
    highlight_selection = true,
    highlight_headers = true,
    auto_follow_cursor = true,
    references_display = 'virtual',  -- or 'write' if you prefer
    
    -- Custom headers for better visual distinction
    question_header = '## 👤 You ',
    answer_header = '## 🤖 Copilot ',
    error_header = '## ❌ Error ',
    separator = '───',
    
    -- Useful prompts configuration
    prompts = {
        -- Add custom prompts
        QuickExplain = {
            prompt = 'Explain this code briefly in 2-3 sentences.',
            mapping = '<leader>ce',
            description = 'Quick code explanation',
        },
        Optimize = {
            prompt = 'How can I optimize this code for better performance?',
            mapping = '<leader>co',
            description = 'Code optimization suggestions',
        },
        Review = {
            prompt = 'Review this code for potential issues, bugs, or improvements.',
            mapping = '<leader>cr',
            description = 'Code review',
        },
        Tests = {
            prompt = 'Generate unit tests for this code.',
            mapping = '<leader>ct',
            description = 'Generate tests',
        },
    },
})

-- Enhanced keymaps for better workflow
local keymap = vim.keymap.set

-- Main CopilotChat commands
keymap('n', '<leader>cc', ':CopilotChatToggle<CR>', { desc = 'Toggle Copilot Chat' })
keymap('n', '<leader>co', ':CopilotChatOpen<CR>', { desc = 'Open Copilot Chat' })
keymap('n', '<leader>cx', ':CopilotChatClose<CR>', { desc = 'Close Copilot Chat' })
keymap('n', '<leader>cr', ':CopilotChatReset<CR>', { desc = 'Reset Copilot Chat' })

-- Quick actions with visual selection
keymap('v', '<leader>ce', ':CopilotChatExplain<CR>', { desc = 'Explain selection' })
keymap('v', '<leader>cr', ':CopilotChatReview<CR>', { desc = 'Review selection' })
keymap('v', '<leader>cf', ':CopilotChatFix<CR>', { desc = 'Fix selection' })
keymap('v', '<leader>co', ':CopilotChatOptimize<CR>', { desc = 'Optimize selection' })
keymap('v', '<leader>ct', ':CopilotChatTests<CR>', { desc = 'Generate tests' })

-- Context-aware commands
keymap('n', '<leader>cf', function()
    local input = vim.fn.input("Ask Copilot: ")
    if input ~= "" then
        require("CopilotChat").ask(input, { context = "buffer" })
    end
end, { desc = 'Ask about current file' })

keymap('n', '<leader>cg', function()
    local input = vim.fn.input("Ask about git changes: ")
    if input ~= "" then
        require("CopilotChat").ask(input, { context = "git:staged" })
    end
end, { desc = 'Ask about git changes' })

-- Model and agent selection
keymap('n', '<leader>cm', ':CopilotChatModels<CR>', { desc = 'Select Copilot model' })
keymap('n', '<leader>ca', ':CopilotChatAgents<CR>', { desc = 'Select Copilot agent' })

-- Utility functions
keymap('n', '<leader>cs', ':CopilotChatSave<CR>', { desc = 'Save chat history' })
keymap('n', '<leader>cl', ':CopilotChatLoad<CR>', { desc = 'Load chat history' })

-- Fix CopilotChat buffer settings
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = 'copilot-*',
    callback = function()
        -- Better buffer settings for chat
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = false
        vim.opt_local.spell = false
    end
})

vim.o.splitright = true

require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})
