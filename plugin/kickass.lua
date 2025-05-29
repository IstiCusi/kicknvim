local kickass = require("kickass")

vim.api.nvim_create_user_command("KickAssemble", kickass.assemble_current_file, {})
vim.api.nvim_create_user_command("KickRun", kickass.run_prg, {})


vim.api.nvim_create_autocmd("FileType", {
  pattern = "kickass",
  callback = function(args)
    local keys = kickass.get_config().keys
    vim.keymap.set("n", keys.assemble, kickass.assemble_current_file, { buffer = args.buf, desc = "Assemble with KickAss" })
    vim.keymap.set("n", keys.run, kickass.run_prg, { buffer = args.buf, desc = "Run PRG with VICE" })
  end,
})
