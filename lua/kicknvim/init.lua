local M = {}

-- ======================== PLUGIN FUNCTONS ==============================
local config = {
  kickass_path = "/home/phonon/Development/lang/C64-KickAssembler/KickAss.jar",
  x64_path = "x64", 
  kickass_man = false,
  keys = {
    assemble = "<leader>ka",
    run = "<leader>kr",
    libinstall = "<leader>kl"
  }, 
  repos = {
    "https://github.com/c64lib/common.git",
    "https://github.com/c64lib/chipset.git",
    "https://github.com/c64lib/text.git",
    "https://github.com/c64lib/copper64.git",
  }
}

-- function M.setup(opts)
--   opts = opts or {}
--   config.kickass_path = opts.kickass_path or config.kickass_path
--   config.x64_path = opts.x64_path or config.x64_path
--   if opts.keys then
--     config.keys = vim.tbl_extend("force", config.keys, opts.keys)
--   end
-- end
--
-- function M.get_config()
--   return config
-- end


function M.setup(opts)
  opts = opts or {}

  -- Konfiguration übernehmen
  config.kickass_path = opts.kickass_path or config.kickass_path
  config.x64_path = opts.x64_path or config.x64_path
  config.kickass_man = opts.kickass_man or config.kickass_man

  if opts.keys then
    config.keys = vim.tbl_extend("force", config.keys, opts.keys)
  end

  -- Optional: manpages installieren/deinstallieren
  if opts.kickass_man ~= nil then
    local dst_dir = vim.fn.expand("~/.local/share/man/man99")
    local already_installed = vim.fn.glob(dst_dir .. "/*.99") ~= ""

    if opts.kickass_man == true and not already_installed then
      M.install_manpages()
    elseif opts.kickass_man == false and already_installed then
      M.uninstall_manpages()
    end
  end

  -- Autocommand nur hier, weil config jetzt vollständig ist
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "kickass",
    callback = function(args)
      local keys = config.keys
      vim.keymap.set("n", keys.assemble, M.assemble_current_file, { buffer = args.buf, desc = "Assemble with KickAss" })
      vim.keymap.set("n", keys.run, M.run_prg, { buffer = args.buf, desc = "Run PRG with VICE" })
      if keys.libinstall then
        vim.keymap.set("n", keys.libinstall, M.install_or_update_libs, { buffer = args.buf, desc = "Install/Update KickAsm libraries" })
      end
    end,
  })
end



function M.install_manpages()
  local plugin_path = vim.fn.stdpath("data") .. "/lazy/kicknvim"
  local src_dir = plugin_path .. "/manpages/man99"
  local dst_dir = vim.fn.expand("~/.local/share/man/man99")

  vim.fn.mkdir(dst_dir, "p")

  for _, file in ipairs(vim.fn.glob(src_dir .. "/*.99", false, true)) do
    local dest_file = dst_dir .. "/" .. vim.fn.fnamemodify(file, ":t")
    vim.fn.writefile(vim.fn.readfile(file), dest_file)
  end

  vim.fn.system({ "mandb", vim.fn.expand("~/.local/share/man") })
  vim.notify("KickNvim manpages installed", vim.log.levels.INFO)
end

function M.uninstall_manpages()
  local dst_dir = vim.fn.expand("~/.local/share/man/man99")
  local files = vim.fn.glob(dst_dir .. "/*.99", false, true)

  for _, file in ipairs(files) do
    vim.fn.delete(file)
  end

  if vim.fn.empty(vim.fn.glob(dst_dir .. "/*")) == 1 then
    vim.fn.delete(dst_dir, "d")
  end

  vim.fn.system({ "mandb", vim.fn.expand("~/.local/share/man") })
  vim.notify("KickNvim manpages removed", vim.log.levels.INFO)
end


-- ======================== HELPER FUNCTIONS =============================

-- Gives back the path of the bin folder used for compilation
local function ensure_bin_dir()
  local bin_path = vim.fn.expand("%:p:h") .. "/bin"
  if vim.fn.isdirectory(bin_path) == 0 then
    vim.fn.mkdir(bin_path, "p")
  end
  return bin_path
end

-- Checks if the filetype of the active buffer is kickass
local function is_kickass_file()
  return vim.bo.filetype == "kickass"
end

-- =======================================================================

function M.open_kmanual()
  local  cmd = "xdg-open https://theweb.dk/KickAssembler/webhelp/content/cpt_Introduction.html"
  vim.fn.system(cmd)
  print("Opened KickAssembler Manual")
end

function M.open_libmanual()
  local  cmd = "https://c64lib.github.io/"
  vim.fn.system(cmd)
  print("Opened C64Lib Manual")
end


function M.assemble_current_file()
  if not is_kickass_file() then
    print("Active buffer is not a kickassembler file")
    return
  end
  local src = vim.fn.expand("%:p")
  local bin_dir = ensure_bin_dir()
  local base = vim.fn.expand("%:t:r")
  local output = bin_dir .. "/" .. base .. ".prg"
  local sym_file = bin_dir .. "/" .. base .. ".sym"
  local vs_file = bin_dir .. "/" .. base .. ".vs"
  local dbg_file = bin_dir .. "/" .. base .. ".dbg"
  local cmd = string.format(
    'java -jar %s %s -odir %s -o %s -symbolfile %s -vicesymbols -vicedebug -debugdump',
    config.kickass_path, src, bin_dir, output, sym_file
  )
  vim.fn.system(cmd)
  print("Compiled to " .. output)
end

function M.run_prg()
  if not is_kickass_file() then
    print("Active buffer is not a KickAssembler file")
    return
  end
  local bin_dir = ensure_bin_dir()
  local base = vim.fn.expand("%:t:r")
  local prg_file = bin_dir .. "/" .. base .. ".prg"
  local sym_file = bin_dir .. "/" .. base .. ".sym"
  local vs_file = bin_dir .. "/" .. base .. ".vs"
  local labels_file = bin_dir .. "/" .. base .. ".labels"

  vim.fn.jobstart({
    config.x64_path,
    "-moncommands", vs_file,
    prg_file
  }, { detach = true })
end

function M.install_or_update_libs()
  if not is_kickass_file() then
    print("Active buffer is not a KickAssembler file")
    return
  end

  local buffer_path = vim.fn.expand("%:p:h")
  local lib_path = buffer_path .. "/lib"

  if vim.fn.isdirectory(lib_path) == 0 then
    print("Creating lib directory at " .. lib_path)
    vim.fn.mkdir(lib_path, "p")
  end

  for _, repo_url in ipairs(config.repos) do
    local repo_name = repo_url:match("([^/]+)%.git$")
    local target_path = lib_path .. "/" .. repo_name
    if vim.fn.isdirectory(target_path) == 0 then
      print("Cloning " .. repo_name .. "...")
      vim.fn.system({ "git", "clone", repo_url, target_path })
    else
      print("Updating " .. repo_name .. "...")
      vim.fn.system({ "git", "-C", target_path, "pull" })
    end
  end
end


return M
