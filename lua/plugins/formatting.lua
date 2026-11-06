-- Format-on-save routing: conform.nvim is LazyVim's primary formatter, so a
-- kotlin entry here makes kotlin-lsp's own documentFormattingProvider a no-op
-- on save (lsp_format = "fallback" in LazyVim's conform opts).
return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        kotlin = { "ktlint" },
      },
      formatters = {
        ktlint = {
          -- Run from the project root so the repo's .editorconfig applies.
          cwd = require("conform.util").root_file({
            "gradlew",
            "settings.gradle.kts",
            "settings.gradle",
            ".editorconfig",
          }),
        },
      },
    },
  },
}
