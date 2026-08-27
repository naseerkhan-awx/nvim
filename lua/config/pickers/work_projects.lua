local M = {}

local projects_script = vim.fs.joinpath(vim.env.HOME, "dotfiles", "scripts", "projects")
local work_dir = vim.fs.joinpath(vim.env.HOME, "Desktop", "Work")

local function restart_in(path)
  if vim.fn.isdirectory(path) ~= 1 then
    Snacks.notify.error("Project directory does not exist: " .. path)
    return
  end

  local ok, err = pcall(vim.cmd, "restart cd " .. vim.fn.fnameescape(path))
  if not ok then
    Snacks.notify.error(err, { title = "Project switch failed" })
  end
end

local function open_project(item)
  local local_path = item.local_path
  if local_path then
    restart_in(local_path)
    return
  end

  local gitlab_url = item.gitlab_url
  if not gitlab_url then
    Snacks.notify.error("Project has no local path or GitLab URL: " .. item.name)
    return
  end

  local target = vim.fs.joinpath(work_dir, item.name)
  if vim.fn.isdirectory(target) == 1 then
    restart_in(target)
    return
  end

  vim.fn.mkdir(work_dir, "p")
  Snacks.notify.info("Cloning " .. item.name .. "…", { title = "Projects" })

  vim.system({ "git", "clone", "--", gitlab_url, target }, { text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        local message = vim.trim(result.stderr or "")
        Snacks.notify.error(message ~= "" and message or "git clone failed", {
          title = "Could not clone " .. item.name,
        })
        return
      end

      restart_in(target)
    end)
  end)
end

function M.finder(_, ctx)
  local process = require("snacks.picker.source.proc").proc({
    cmd = projects_script,
    args = { "--list", "--format=json" },
    raw = true,
  }, ctx)

  return function(cb)
    local output = {}
    process(function(item)
      output[#output + 1] = item.text
    end)

    local ok, projects = pcall(vim.json.decode, table.concat(output))
    if not ok or not vim.islist(projects) then
      Snacks.notify.error(ok and "Expected a JSON array" or projects, {
        title = "Could not load projects",
      })
      return
    end

    for _, item in ipairs(projects) do
      item.local_path = item.local_path ~= vim.NIL and item.local_path or nil
      item.gitlab_url = item.gitlab_url ~= vim.NIL and item.gitlab_url or nil

      local searchable = { item.name, item.gitlab_url or "", item.local_path or "" }
      vim.list_extend(searchable, item.gradle_paths or {})

      item.text = table.concat(searchable, " ")
      item.file = item.local_path
      item.dir = item.local_path ~= nil
      cb(item)
    end
  end
end

function M.format(item)
  local is_local = item.local_path ~= nil
  local icon = is_local and " " or "󰒍 "
  local detail = is_local and vim.fn.fnamemodify(item.local_path, ":~") or "clone from GitLab"

  return {
    { icon, is_local and "Directory" or "DiagnosticInfo" },
    { item.name, "SnacksPickerLabel" },
    { "  " .. detail, "Comment" },
  }
end

function M.confirm(picker, item)
  picker:close()
  if item then
    vim.schedule(function()
      open_project(item)
    end)
  end
end

return {
  title = "Work Projects",
  finder = M.finder,
  format = M.format,
  confirm = M.confirm,
  matcher = {
    frecency = true,
    sort_empty = true,
    cwd_bonus = false,
  },
  sort = { fields = { "score:desc", "idx" } },
  win = {
    preview = { minimal = true },
  },
}
