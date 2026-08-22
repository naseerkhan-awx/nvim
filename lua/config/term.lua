-- Toggleterm sessions with IDE-style panels:
--   Cmd+J  bottom panel (one window, multiple tabs)
--   Cmd+I  right panel running `agent`
--   n      new tab in the current panel
--   Opt+H/L  previous / next tab
--
-- Toggleterm cannot mix horizontal + vertical layouts on its own
-- (opening a second direction splits the first). Windows are opened here;
-- toggleterm only owns the terminal jobs and buffers.

local M = {}

---@type table<string, number> last focused terminal id per panel
local last = {}

local function terms()
  return require("toggleterm.terminal")
end

local function root()
  return LazyVim.root.git()
end

---@return Terminal?
local function current()
  local id = vim.b.toggle_number
  if id then
    return terms().get(id, true)
  end
  local _, term = terms().identify()
  return term
end

---@param panel string
---@return Terminal[]
local function panel_terms(panel)
  local list = {}
  for _, term in ipairs(terms().get_all(true)) do
    if term.panel == panel then
      list[#list + 1] = term
    end
  end
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  return list
end

---@param panel string
---@return integer?
local function panel_win(panel)
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local id = vim.b[vim.api.nvim_win_get_buf(win)].toggle_number
    if id then
      local term = terms().get(id, true)
      if term and term.panel == panel then
        return win
      end
    end
  end
end

---@param panel string
local function refresh_winbar(panel)
  local list = panel_terms(panel)
  for _, term in ipairs(list) do
    if term.window and vim.api.nvim_win_is_valid(term.window) and term:is_open() then
      if #list < 2 then
        vim.wo[term.window].winbar = ""
      else
        local parts = {}
        for i, sibling in ipairs(list) do
          local name = sibling.display_name or tostring(i)
          if sibling.id == term.id then
            parts[#parts + 1] = "%#TabLineSel# " .. name .. " "
          else
            parts[#parts + 1] = "%#TabLine# " .. name .. " "
          end
        end
        vim.wo[term.window].winbar = table.concat(parts)
      end
    end
  end
end

---@param term Terminal
---@param win integer
---@param opts? { insert?: boolean }
local function show_in_win(term, win, opts)
  opts = opts or {}
  if not term.bufnr or not vim.api.nvim_buf_is_valid(term.bufnr) then
    term:spawn()
  end

  -- Set before BufEnter so persist_mode restores the intended state.
  if opts.insert == false then
    term.__state.mode = "n"
  elseif opts.insert == true then
    term.__state.mode = "i"
  end

  vim.api.nvim_win_set_buf(win, term.bufnr)
  term.window = win
  vim.b[term.bufnr].toggle_number = term.id
  last[term.panel] = term.id

  if term.direction == "horizontal" then
    vim.wo[win].winfixheight = true
  else
    vim.wo[win].winfixwidth = true
  end
  -- LazyVim keeps signcolumn/statuscolumn on globally; Snacks hid them in terminals.
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].foldcolumn = "0"
  vim.wo[win].statuscolumn = ""

  require("toggleterm.ui").hl_term(term)
  refresh_winbar(term.panel)

  vim.api.nvim_set_current_win(win)
  if opts.insert ~= nil then
    vim.schedule(function()
      vim.cmd(opts.insert and "startinsert" or "stopinsert")
    end)
  end
end

---@param opts table
---@return Terminal
local function create(opts)
  return terms().Terminal:new(vim.tbl_extend("force", {
    dir = root(),
    close_on_exit = false,
    on_exit = function(term)
      vim.schedule(function()
        local win = term.window
        local panel = term.panel
        local siblings = panel_terms(panel)
        if win and vim.api.nvim_win_is_valid(win) then
          if #siblings > 0 then
            show_in_win(siblings[#siblings], win, { insert = false })
          else
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
        if term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr) then
          pcall(vim.api.nvim_buf_delete, term.bufnr, { force = true })
        end
        if panel then
          refresh_winbar(panel)
        end
      end)
    end,
  }, opts))
end

---@param panel string
---@return Terminal?
local function last_term(panel)
  local id = last[panel]
  if id then
    local term = terms().get(id, true)
    if term then
      return term
    end
  end
  return panel_terms(panel)[1]
end

---@param term Terminal
function M.attach(term)
  if not term.panel then
    term.panel = "term-" .. term.id
  end

  local buf = term.bufnr
  if not buf or vim.b[buf].term_maps then
    return
  end
  vim.b[buf].term_maps = true

  vim.keymap.set("n", "n", M.new_tab, { buffer = buf, desc = "New Terminal Tab" })
  vim.keymap.set({ "n", "t" }, "<M-H>", function()
    M.cycle(-1)
  end, { buffer = buf, desc = "Prev Terminal Tab" })
  vim.keymap.set({ "n", "t" }, "<M-L>", function()
    M.cycle(1)
  end, { buffer = buf, desc = "Next Terminal Tab" })

  -- Same as Snacks: first Esc goes to the job, second Esc leaves insert.
  vim.keymap.set("t", "<Esc>", function()
    local prev = vim.b[buf].term_esc_at
    local now = vim.uv.now()
    vim.b[buf].term_esc_at = now
    if prev and now - prev < 200 then
      return "<C-\\><C-n>"
    end
    return "<Esc>"
  end, { buffer = buf, expr = true, desc = "Double Escape to Normal Mode" })
end

---@param win integer
local function hide_panel(win)
  local id = vim.b[vim.api.nvim_win_get_buf(win)].toggle_number
  local term = id and terms().get(id, true)
  if term then
    last[term.panel] = term.id
    term:persist_mode()
  end
  pcall(vim.api.nvim_win_close, win, true)
end

function M.focus_bottom()
  local win = panel_win("bottom")
  if win then
    if win == vim.api.nvim_get_current_win() then
      hide_panel(win)
      return
    end
    local id = vim.b[vim.api.nvim_win_get_buf(win)].toggle_number
    local term = id and terms().get(id, true)
    if term then
      term.__state.mode = "i"
    end
    vim.api.nvim_set_current_win(win)
    vim.schedule(function()
      vim.cmd("startinsert")
    end)
    return
  end

  local term = last_term("bottom")
    or create({
      panel = "bottom",
      direction = "horizontal",
      display_name = "1",
    })

  vim.cmd("botright split")
  vim.cmd("resize " .. math.max(5, math.floor(vim.o.lines * 0.3)))
  show_in_win(term, vim.api.nvim_get_current_win(), { insert = true })
end

function M.focus_agent()
  local term = terms().find(function(t)
    return t.panel == "agent" and t.cmd == "agent"
  end)
  local first_open = term == nil
  term = term
    or create({
      cmd = "agent",
      panel = "agent",
      direction = "vertical",
      display_name = "agent",
    })

  -- First open starts in insert; later visits restore insert/normal.
  local opts = first_open and { insert = true } or nil

  local win = panel_win("agent")
  if win then
    if win == vim.api.nvim_get_current_win() then
      hide_panel(win)
      return
    end
    show_in_win(term, win, opts)
    return
  end

  vim.cmd("botright vsplit")
  vim.cmd("vertical resize " .. math.max(20, math.floor(vim.o.columns * 0.3)))
  show_in_win(term, vim.api.nvim_get_current_win(), opts)
end

function M.new_tab()
  local term = current()
  if not term then
    return
  end
  term:persist_mode()
  local new = create({
    panel = term.panel,
    direction = term.direction,
    display_name = tostring(#panel_terms(term.panel) + 1),
  })
  show_in_win(new, vim.api.nvim_get_current_win(), { insert = true })
end

---@param step integer
function M.cycle(step)
  local term = current()
  if not term then
    return
  end
  local list = panel_terms(term.panel)
  if #list < 2 then
    return
  end
  local idx = 1
  for i, sibling in ipairs(list) do
    if sibling.id == term.id then
      idx = i
      break
    end
  end
  term:persist_mode()
  local next_term = list[((idx - 1 + step) % #list) + 1]
  show_in_win(next_term, vim.api.nvim_get_current_win())
end

return M
