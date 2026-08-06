return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<D-S-g>", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open", mode = { "n", "i", "v" } },
      { "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "DiffView Branch History" },
    },
    opts = {
      keymaps = {
        view = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
      },
    },
  },
}
