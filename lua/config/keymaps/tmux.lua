-- Pane for this terminal only if it is an attached tmux client on an active window.
local function active_tmux_pane(buf)
  local chan = vim.b[buf].terminal_job_id
  if not chan or vim.fn.executable("tmux") == 0 then
    return nil
  end
  local pty = vim.api.nvim_get_chan_info(chan).pty
  if not pty or pty == "" then
    return nil
  end
  pty = vim.fn.resolve(pty)

  local out = vim.fn.system({
    "tmux",
    "list-clients",
    "-F",
    "#{client_tty}\t#{pane_id}\t#{window_active}",
  })
  if vim.v.shell_error ~= 0 then
    return nil
  end
  for line in vim.gsplit(out, "\n", { trimempty = true }) do
    local tty, pane, active = line:match("^(%S+)\t(%S+)\t(%S+)$")
    if tty and vim.fn.resolve(tty) == pty and active == "1" then
      return pane
    end
  end
  return nil
end

local function tmux(args)
  vim.fn.jobstart(vim.list_extend({ "tmux" }, args), { detach = true })
end

local function with_active_tmux(buf, fn)
  return function()
    local pane = active_tmux_pane(buf)
    if not pane then
      return
    end
    fn(pane)
  end
end

-- Same feel as buffers.lua H/L: scroll 3 lines, then pin to the screen edge.
local function tmux_scroll(buf, motion, edge)
  local pane = active_tmux_pane(buf)
  if not pane then
    return false
  end
  vim.fn.system({ "tmux", "copy-mode", "-t", pane })
  vim.fn.system({ "tmux", "send-keys", "-t", pane, "-X", "-N", "3", motion })
  vim.fn.system({ "tmux", "send-keys", "-t", pane, "-X", edge })
  return true
end

local function nvim_scroll(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(args)
    local buf = args.buf

    vim.keymap.set(
      "n",
      "n",
      with_active_tmux(buf, function(pane)
        tmux({ "new-window", "-t", pane })
      end),
      { buffer = buf, desc = "Tmux New Window" }
    )
    vim.keymap.set(
      { "n", "t" },
      "<D-w>",
      with_active_tmux(buf, function(pane)
        tmux({ "kill-window", "-t", pane })
      end),
      { buffer = buf, desc = "Tmux Kill Window" }
    )
    vim.keymap.set(
      { "n", "t" },
      "<M-H>",
      with_active_tmux(buf, function(pane)
        tmux({ "previous-window", "-t", pane })
      end),
      { buffer = buf, desc = "Tmux Previous Window" }
    )
    vim.keymap.set(
      { "n", "t" },
      "<M-L>",
      with_active_tmux(buf, function(pane)
        tmux({ "next-window", "-t", pane })
      end),
      { buffer = buf, desc = "Tmux Next Window" }
    )

    vim.keymap.set("n", "H", function()
      if not tmux_scroll(buf, "scroll-up", "top-line") then
        nvim_scroll("<C-Y><C-Y><C-Y>H")
      end
    end, { buffer = buf, desc = "Scroll up" })
    vim.keymap.set("n", "L", function()
      if not tmux_scroll(buf, "scroll-down", "bottom-line") then
        nvim_scroll("<C-E><C-E><C-E>L")
      end
    end, { buffer = buf, desc = "Scroll down" })

    -- i / a / I / A (and any other insert path) leave tmux copy-mode.
    vim.api.nvim_create_autocmd("TermEnter", {
      buffer = buf,
      callback = function()
        local pane = active_tmux_pane(buf)
        if not pane then
          return
        end
        vim.fn.system({ "tmux", "send-keys", "-t", pane, "-X", "cancel" })
      end,
    })
  end,
})
