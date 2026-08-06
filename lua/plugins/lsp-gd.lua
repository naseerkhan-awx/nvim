-- JetBrains-style "declaration or usages": gd → definition, or references if already there.
local function definition_or_references()
  local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/definition" })
  if #clients == 0 then
    return
  end

  local encoding = clients[1].offset_encoding or "utf-16"
  local params = vim.lsp.util.make_position_params(0, encoding)

  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result)
    if err then
      vim.notify(err.message, vim.log.levels.ERROR)
      return
    end

    local locations = result or {}
    if not vim.islist(locations) then
      locations = vim.tbl_isempty(locations) and {} or { locations }
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]

    local function is_current_line(loc)
      local uri = loc.uri or loc.targetUri
      local range = loc.range or loc.targetSelectionRange or loc.targetRange
      if not uri or not range then
        return false
      end
      if vim.uri_to_bufnr(uri) ~= bufnr then
        return false
      end
      return (range.start.line + 1) == cursor_line
    end

    local elsewhere = vim.tbl_filter(function(loc)
      return not is_current_line(loc)
    end, locations)

    -- Already on the definition (or no useful definition) → references
    if #elsewhere == 0 then
      if Snacks and Snacks.picker and Snacks.picker.lsp_references then
        Snacks.picker.lsp_references()
      else
        vim.lsp.buf.references()
      end
      return
    end

    if #elsewhere == 1 then
      local loc = elsewhere[1]
      local uri = loc.uri or loc.targetUri
      local range = loc.range or loc.targetSelectionRange or loc.targetRange
      vim.lsp.util.show_document({ uri = uri, range = range }, encoding, { focus = true })
      return
    end

    -- Multiple definitions → picker / default definition UI
    if Snacks and Snacks.picker and Snacks.picker.lsp_definitions then
      Snacks.picker.lsp_definitions()
    else
      vim.lsp.buf.definition()
    end
  end)
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            {
              "gd",
              definition_or_references,
              desc = "Goto Definition or References",
              has = "definition",
            },
          },
        },
      },
    },
  },
}
