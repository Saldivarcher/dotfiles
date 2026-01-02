-- Neovim LSP configuration (cleaned + fixes)
-- Avoids deprecated nvim-lspconfig "framework" usage by using vim.lsp.start and vim.fs
-- Adjust executable names (basedpyright-langserver, clangd, rust-analyzer, fortls) as needed.

-- Helper: find a project python interpreter (best-effort)
local uv = vim.loop
local function get_python_path(workspace)
  -- prefer VIRTUAL_ENV if set
  local venv_env = os.getenv("VIRTUAL_ENV")
  if venv_env and #venv_env > 0 then
    return venv_env .. "/bin/python"
  end

  -- common venv locations
  local candidates = {
    workspace .. "/.venv/bin/python",
    workspace .. "/venv/bin/python",
    workspace .. "/.venv/Scripts/python.exe",
    workspace .. "/venv/Scripts/python.exe",
  }
  for _, p in ipairs(candidates) do
    if uv.fs_stat(p) then
      return p
    end
  end

  -- fallback to system python
  if vim.fn.exepath("python3") ~= "" then
    return vim.fn.exepath("python3")
  else
    return vim.fn.exepath("python")
  end
end

-- single on_attach for all servers (buffer-local LSP keymaps, highlights)
local on_attach = function(client, bufnr)
  -- document highlights
  if client.server_capabilities and client.server_capabilities.documentHighlightProvider then
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

-- capabilities for completion via nvim-cmp
local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- ---------------------
-- Clangd (C/C++) - using vim.lsp.start (consistent with filetype autocommands)
-- ---------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "cc" },
  callback = function()
    vim.lsp.start({
      name = "clangd",
      cmd = {
        "clangd",
        "-j=4",
        "--background-index",
        "--enable-config",
        "--query-driver=/usr/bin/clang++",
      },
      root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end,
})

-- ---------------------
-- Fortran LSP (fortls)
-- ---------------------
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

-- ---------------------
-- Python LSP (basedpyright / pyright) — avoids deprecated lspconfig usage
-- ---------------------
local python_root_files = { "pyproject.toml", "setup.cfg", "setup.py", "Pipfile", "pyrightconfig.json", ".git" }

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    local start_dir = nil
    if bufname and bufname ~= "" then
      start_dir = vim.fs.dirname(bufname)
    else
      start_dir = vim.loop.cwd()
    end

    local found = vim.fs.find(python_root_files, { path = start_dir, upward = true })[1]
    local root = nil
    if found then
      root = vim.fs.dirname(found)
    else
      root = vim.loop.cwd()
    end

    -- select server binary (prefer basedpyright if present)
    local server_bin = nil
    if vim.fn.exepath("basedpyright-langserver") ~= "" then
      server_bin = "basedpyright-langserver"
    elseif vim.fn.exepath("basedpyright") ~= "" then
      server_bin = "basedpyright"
    elseif vim.fn.exepath("pyright-langserver") ~= "" then
      server_bin = "pyright-langserver"
    else
      -- fallback to pyright if installed via npm as "pyright"
      server_bin = "pyright-langserver"
    end

    local server_cmd = { server_bin, "--stdio" }

    -- compose settings (e.g., pythonPath)
    local py_path = get_python_path(root)
    local settings = {
      python = {
        pythonPath = py_path,
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    }

    -- start language server for this buffer/workspace
    vim.lsp.start({
      name = "basedpyright",
      cmd = server_cmd,
      root_dir = root,
      on_attach = function(client, bufnr)
        -- if using null-ls for formatting, disable server formatting
        if client.server_capabilities and client.server_capabilities.documentFormattingProvider then
          client.server_capabilities.documentFormattingProvider = false
        end
        if on_attach then on_attach(client, bufnr) end
        if client.server_capabilities and client.server_capabilities.inlayHintProvider then
          pcall(vim.lsp.inlay_hint, bufnr, true)
        end
      end,
      capabilities = capabilities,
      settings = settings,
    })
  end,
})

-- ---------------------
-- Rust analyzer
-- ---------------------
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

-- ---------------------
-- UI / completion (nvim-cmp + luasnip)
-- ---------------------
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
