-- Modern on_attach function using vim.keymap.set for buffer-local mappings
local on_attach = function(client, bufnr)
  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end

  vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', '<leader>gc', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<leader>gh', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<leader>gt', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- clangd for C/C++
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cc" },
  callback = function()
    vim.lsp.start({
      name = "clangd",
      cmd = {
        "clangd",
        "-j=32",
        "--background-index",
        "--enable-config",
        "--query-driver=/usr/bin/g++-12",
      },
      root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

-- fortls for Fortran
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fortran" },
  callback = function()
    vim.lsp.start({
      name = "fortls",
      cmd = {
        'fortls',
        '--autocomplete_name_only',
        '--incremental_sync',
        '--lowercase_intrinsics',
        '--notify_init',
      },
      root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["fortran-ls"] = {
          variableHover = false,
          nthreads = 8,
        },
      },
    })
  end,
})

-- pylsp for Python
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.lsp.start({
      name = "pylsp",
      cmd = { "pylsp", "--check-parent-process" },
      root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            yapf = { enabled = true },
          },
        },
      },
    })
  end,
})

-- rust-analyzer for Rust
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "rust" },
  callback = function()
    vim.lsp.start({
      name = "rust_analyzer",
      cmd = { "rust-analyzer" },
      root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = false,
          },
        },
      },
    })
  end,
})

-- nvim-cmp, luasnip, lspkind config (unchanged)
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local luasnip = require 'luasnip'
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'copilot' },
  }
}

local lspkind = require("lspkind")
lspkind.init({
  symbol_map = {
    Copilot = "",
  },
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
