-- Official JetBrains kotlin-lsp via kotlin.nvim (decompile, jar:// navigation, etc.).
-- Do not enable lazyvim.plugins.extras.lang.kotlin — that wires the community server.
return {
  -- Let kotlin.nvim own the server; keep LazyVim/mason from auto-attaching kotlin_lsp.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        kotlin_lsp = { enabled = false },
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
  {
    "stevearc/oil.nvim",
    opts = {},
    lazy = true,
  },
  {
    "AlexandrosAlexiou/kotlin.nvim",
    ft = { "kotlin" },
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "oil.nvim",
      "trouble.nvim",
    },
    config = function()
      require("kotlin").setup({
        root_markers = {
          "settings.gradle.kts",
          "settings.gradle",
          "gradlew",
          "pom.xml",
          "build.gradle.kts",
          "build.gradle",
          ".git",
        },
        jvm_args = {
          "-Xmx4g",
        },
        -- Prefer analyzing against the JDK from JAVA_HOME when set (e.g. SDKMAN).
        jdk_for_symbol_resolution = vim.env.JAVA_HOME,
      })
    end,
  },
}
