return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      { "<D-S-g>", "<cmd>DiffviewOpen<cr>", desc = "DiffView Open", mode = { "n", "i", "v" } },
      { "<D-y>", "<cmd>DiffviewFileHistory %<cr>", desc = "DiffView File History" },
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
          { "n", "X", false },
        },
        file_history_panel = {
          { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } },
        },
      },
    },
    config = function(_, opts)
      local restore_entry = require("diffview.config").actions.restore_entry
      table.insert(opts.keymaps.file_panel, { "n", "d", restore_entry, { desc = "Restore entry" } })
      require("diffview").setup(opts)
    end,
  },
}
