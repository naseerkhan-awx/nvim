return {
  {
    "esmuellert/codediff.nvim",
    cmd = "CodeDiff",
    keys = {
      { "<D-S-g>", "<cmd>CodeDiff<cr>", desc = "CodeDiff Open", mode = { "n", "i", "v" } },
      { "<D-y>", "<cmd>CodeDiff history %<cr>", desc = "CodeDiff File History" },
      { "<leader>gV", "<cmd>CodeDiff history %<cr>", desc = "CodeDiff File History" },
      { "<leader>gH", "<cmd>CodeDiff history<cr>", desc = "CodeDiff Branch History" },
      { "<leader>gm", "<cmd>CodeDiff merge %<cr>", desc = "CodeDiff Resolve Conflicts" },
    },
    opts = {
      diff = {
        layout = "side-by-side",
        conflict_ours_position = "left",
        conflict_result_position = "center",
        conflict_result_width_ratio = { 1, 2, 1 },
      },
    },
  },
}
