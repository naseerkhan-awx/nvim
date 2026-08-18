return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
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
