local M = {}

--- Set the Ghostty / terminal tab title from the session cwd (and optionally argv).
---@param opts? { respect_argv?: boolean }
function M.apply(opts)
  opts = vim.tbl_extend("force", { respect_argv = true }, opts or {})

  local session_title = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  if opts.respect_argv and vim.fn.argc() == 1 then
    local target = vim.fn.argv(0)
    if vim.fn.isdirectory(target) == 0 then
      session_title = vim.fn.fnamemodify(target, ":t")
    end
  end

  vim.opt.title = true
  vim.opt.titlestring = session_title
end

return M
