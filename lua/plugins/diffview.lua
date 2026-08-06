return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      -- Avoid <leader>gd / <leader>gh — used by Snacks git diff and Gitsigns hunks.
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open" },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "DiffView Branch History" },
    },
  },
}
