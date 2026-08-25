-- Animated spinner while waiting on LSP navigation requests (gd, gi, gr, …).
-- Uses Snacks.notifier directly so it works even when Noice owns vim.notify.
local DELAY_MS = 100 -- avoid flash on fast responses

local NAV = {
  ["textDocument/definition"] = "Go to Definition",
  ["textDocument/declaration"] = "Go to Declaration",
  ["textDocument/implementation"] = "Go to Implementation",
  ["textDocument/typeDefinition"] = "Go to Type Definition",
  ["textDocument/references"] = "Find References",
  ["textDocument/rename"] = "Rename Symbol",
  ["callHierarchy/incomingCalls"] = "Incoming Calls",
  ["callHierarchy/outgoingCalls"] = "Outgoing Calls",
}

local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
---@type table<string, uv.uv_timer_t>
local timers = {}

local function notif_id(client_id, request_id)
  return ("lsp_nav_%s_%s"):format(client_id, request_id)
end

local function clear_timer(id)
  local timer = timers[id]
  if not timer then
    return
  end
  timers[id] = nil
  if not timer:is_closing() then
    timer:stop()
    timer:close()
  end
end

local function show(id, title)
  Snacks.notifier.notify(title .. "…", "info", {
    id = id,
    title = "LSP",
    timeout = false,
    history = false,
    opts = function(notif)
      notif.icon = spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
    end,
  })
end

local function hide(id)
  clear_timer(id)
  Snacks.notifier.hide(id)
end

return {
  {
    "folke/snacks.nvim",
    init = function()
      vim.api.nvim_create_autocmd("LspRequest", {
        group = vim.api.nvim_create_augroup("lsp_nav_loading", { clear = true }),
        callback = function(ev)
          local data = ev.data
          if not data or not data.request then
            return
          end

          local request = data.request
          local title = NAV[request.method]
          if not title then
            return
          end

          local id = notif_id(data.client_id, data.request_id)

          if request.type == "pending" then
            clear_timer(id)
            local timer = assert(vim.uv.new_timer())
            timers[id] = timer
            timer:start(DELAY_MS, 0, function()
              timers[id] = nil
              timer:close()
              vim.schedule(function()
                show(id, title)
              end)
            end)
          elseif request.type == "complete" or request.type == "cancel" then
            vim.schedule(function()
              hide(id)
            end)
          end
        end,
      })
    end,
  },
}
