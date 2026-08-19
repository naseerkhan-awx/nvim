local function deduplicated_git_branches(opts, ctx)
  local finder = require("snacks.picker.source.git").branches(opts, ctx)

  return function(cb)
    local seen = {}

    return finder(function(item)
      local branch = item.branch
      if not branch then
        return cb(item)
      end

      -- `git branch --all` lists local branches before remote-tracking
      -- branches, so the local version wins when both exist.
      local name = branch:match("^remotes/[^/]+/(.+)$") or branch
      if seen[name] then
        return
      end

      seen[name] = true
      cb(item)
    end)
  end
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          git_branches = {
            finder = deduplicated_git_branches,
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
