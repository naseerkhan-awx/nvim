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
    init = function()
      local group = vim.api.nvim_create_augroup("CodeDiffListNavigation", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = { "codediff-explorer", "codediff-history" },
        callback = function(event)
          vim.keymap.set("n", "l", "<CR>", {
            buffer = event.buf,
            remap = true,
            silent = true,
            desc = "Select CodeDiff item",
          })
        end,
      })
    end,
    opts = {
      keymaps = {
        view = {
          toggle_explorer = "<D-b>",
        },
        explorer = {
          restore = "d",
        },
      },
      diff = {
        layout = "side-by-side",
        conflict_ours_position = "left",
        conflict_result_position = "center",
        conflict_result_width_ratio = { 1, 1, 1 },
      },
    },
  },
}
