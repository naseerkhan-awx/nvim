return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          git_branches = {
            format = function(item)
              return {
                {
                  item.current and " " or "  ",
                  item.current and "SnacksPickerGitBranchCurrent" or nil,
                },
                {
                  item.detached and "(detached HEAD)" or item.branch,
                  item.detached and "SnacksPickerGitDetached" or "SnacksPickerGitBranch",
                },
              }
            end,
          },
          explorer = {
            hidden = true, -- dotfiles
            ignored = true, -- gitignored (often needed for .env)
            win = {
              list = {
                keys = {
                  ["a"] = false,
                  ["n"] = "explorer_add",
                },
              },
            },
          },
          files = {
            hidden = true,
            ignored = true,
          },
          projects = {
            -- Personal: top-level repos; home-server: nested repos (no .git at root)
            dev = {
              "~/dev",
              "~/projects",
              "~/Desktop/Personal",
              "~/Desktop/Personal/home-server",
              "~/Desktop/Work/",
              "~/Desktop/Work/playground/",
            },
          },
        },
      },
    },
  },
}
