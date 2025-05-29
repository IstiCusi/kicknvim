local kicknvim = require("kicknvim")

vim.api.nvim_create_user_command("KickAssemble", kicknvim.assemble_current_file, {})
vim.api.nvim_create_user_command("KickRun", kicknvim.run_prg, {})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "kickass",
  callback = function(args)
    local keys = kicknvim.get_config().keys
    vim.keymap.set("n", keys.assemble, kicknvim.assemble_current_file, { buffer = args.buf, desc = "Assemble with KickAss" })
    vim.keymap.set("n", keys.run, kicknvim.run_prg, { buffer = args.buf, desc = "Run PRG with VICE" })
  end,
})
