-- VS Code Dark+ syntax accents applied on top of Catppuccin Mocha UI greys.
local vscode = {
  front = "#D4D4D4",
  blue = "#569CD6", -- storage / type keywords, builtins, booleans
  pink = "#C586C0", -- control-flow keywords
  teal = "#4EC9B0", -- types / classes / modules
  lightBlue = "#9CDCFE", -- variables, parameters, properties
  yellow = "#DCDCAA", -- functions, methods, attributes
  orange = "#CE9178", -- strings
  green = "#6A9955", -- comments
  lightGreen = "#B5CEA8", -- numbers
  accentBlue = "#4FC1FF", -- constants
}

return {
  -- LazyVim already vendors catppuccin; enable Mocha as the default theme.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin/nvim",
    opts = {
      flavour = "mocha",
      -- VS Code–style neutral greys; keep base > mantle > crust so buffer / explorer / terminal stay distinct.
      color_overrides = {
        mocha = {
          base = "#1e1e1e", -- editor (VS Code Dark+)
          mantle = "#181818", -- explorer / side panels
          crust = "#141414", -- terminal / deepest chrome
        },
      },
      -- Restyle syntax to Dark+; Catppuccin otherwise paints types yellow and functions blue.
      custom_highlights = function()
        return {
          -- Legacy vim groups
          Comment = { fg = vscode.green, italic = true },
          Constant = { fg = vscode.accentBlue },
          String = { fg = vscode.orange },
          Character = { fg = vscode.orange },
          Number = { fg = vscode.lightGreen },
          Boolean = { fg = vscode.blue },
          Float = { fg = vscode.lightGreen },
          Identifier = { fg = vscode.lightBlue },
          Function = { fg = vscode.yellow },
          Statement = { fg = vscode.pink },
          Conditional = { fg = vscode.pink },
          Repeat = { fg = vscode.pink },
          Label = { fg = vscode.pink },
          Operator = { fg = vscode.front },
          Keyword = { fg = vscode.blue },
          Exception = { fg = vscode.pink },
          PreProc = { fg = vscode.pink },
          Include = { fg = vscode.pink },
          Define = { fg = vscode.pink },
          Macro = { fg = vscode.blue },
          Type = { fg = vscode.teal },
          StorageClass = { fg = vscode.blue },
          Structure = { fg = vscode.teal },
          Typedef = { fg = vscode.teal },
          Special = { fg = vscode.yellow },

          -- Treesitter: keywords
          ["@keyword"] = { fg = vscode.blue },
          ["@keyword.function"] = { fg = vscode.blue },
          ["@keyword.modifier"] = { fg = vscode.blue },
          ["@keyword.type"] = { fg = vscode.blue },
          ["@keyword.coroutine"] = { fg = vscode.blue },
          ["@keyword.operator"] = { fg = vscode.blue },
          ["@keyword.conditional"] = { fg = vscode.pink },
          ["@keyword.repeat"] = { fg = vscode.pink },
          ["@keyword.return"] = { fg = vscode.pink },
          ["@keyword.exception"] = { fg = vscode.pink },
          ["@keyword.import"] = { fg = vscode.pink },
          ["@keyword.export"] = { fg = vscode.pink },
          ["@keyword.debug"] = { fg = vscode.pink },
          ["@keyword.directive"] = { fg = vscode.pink },
          ["@keyword.directive.define"] = { fg = vscode.pink },

          -- Treesitter: types / modules (was Catppuccin yellow)
          ["@type"] = { fg = vscode.teal },
          ["@type.builtin"] = { fg = vscode.blue },
          ["@type.definition"] = { fg = vscode.teal },
          ["@module"] = { fg = vscode.teal },
          ["@constructor"] = { fg = vscode.blue },

          -- Treesitter: functions (Dark+ yellow, not Catppuccin blue)
          ["@function"] = { fg = vscode.yellow },
          ["@function.builtin"] = { fg = vscode.yellow },
          ["@function.call"] = { fg = vscode.yellow },
          ["@function.method"] = { fg = vscode.yellow },
          ["@function.method.call"] = { fg = vscode.yellow },
          ["@function.macro"] = { fg = vscode.yellow },

          -- Treesitter: variables / properties
          ["@variable"] = { fg = vscode.lightBlue },
          ["@variable.builtin"] = { fg = vscode.blue },
          ["@variable.parameter"] = { fg = vscode.lightBlue },
          ["@variable.member"] = { fg = vscode.lightBlue },
          ["@property"] = { fg = vscode.lightBlue },

          -- Treesitter: literals / attributes
          ["@string"] = { fg = vscode.orange },
          ["@string.escape"] = { fg = vscode.orange },
          ["@string.regexp"] = { fg = vscode.orange },
          ["@character"] = { fg = vscode.orange },
          ["@number"] = { fg = vscode.lightGreen },
          ["@number.float"] = { fg = vscode.lightGreen },
          ["@boolean"] = { fg = vscode.blue },
          ["@constant"] = { fg = vscode.accentBlue },
          ["@constant.builtin"] = { fg = vscode.blue },
          ["@attribute"] = { fg = vscode.yellow },
          ["@operator"] = { fg = vscode.front },
          ["@comment"] = { fg = vscode.green, italic = true },
          ["@comment.documentation"] = { fg = vscode.green, italic = true },

          -- LSP semantic tokens
          ["@lsp.type.keyword"] = { link = "@keyword" },
          ["@lsp.typemod.keyword.controlFlow"] = { fg = vscode.pink },
          ["@lsp.type.type"] = { link = "@type" },
          ["@lsp.type.class"] = { link = "@type" },
          ["@lsp.type.interface"] = { link = "@type" },
          ["@lsp.type.enum"] = { link = "@type" },
          ["@lsp.type.struct"] = { link = "@type" },
          ["@lsp.type.namespace"] = { link = "@module" },
          ["@lsp.type.function"] = { link = "@function" },
          ["@lsp.type.method"] = { link = "@function.method" },
          ["@lsp.type.variable"] = { link = "@variable" },
          ["@lsp.type.parameter"] = { link = "@variable.parameter" },
          ["@lsp.type.property"] = { link = "@property" },
          ["@lsp.type.string"] = { link = "@string" },
          ["@lsp.type.number"] = { link = "@number" },
        }
      end,
    },
  },
}
