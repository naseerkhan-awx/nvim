-- Official JetBrains Kotlin LSP (kotlin-lsp), not the community kotlin_language_server.
-- Do not enable lazyvim.plugins.extras.lang.kotlin — that wires the community server.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_lsp = {
          -- Prefer project roots (Gradle/Maven); JetBrains docs recommend this.
          single_file_support = false,
        },
        -- Community fwcd server; keep disabled so Mason auto-enable won't attach it.
        kotlin_language_server = { enabled = false },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "kotlin" } },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "kotlin-lsp" } },
  },
}
