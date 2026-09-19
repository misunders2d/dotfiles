return {
  {
    "Vigemus/iron.nvim",
    ft = "python",
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local common = require("iron.fts.common")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { "ipython", "--no-autoindent" },
              format = common.bracketed_paste_python,
              block_dividers = { "# %%", "#%%" },
            },
          },
          repl_open_cmd = view.bottom(15),
        },
        keymaps = {
          toggle_repl = "<leader>rr",
          restart_repl = "<leader>rR",
          send_motion = "<leader>rs",
          visual_send = "<leader>rs",
          send_line = "<leader>rl",
          send_code_block = "<leader>rb",
          send_code_block_and_move = "<leader>rn",
          send_file = "<leader>rf",
          interrupt = "<leader>ri",
          exit = "<leader>rq",
          clear = "<leader>rC",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      vim.keymap.set("n", "<leader>ro", "<cmd>IronFocus<cr>", { desc = "Focus REPL", buffer = true })
      vim.keymap.set("n", "<leader>rh", "<cmd>IronHide<cr>", { desc = "Hide REPL", buffer = true })
    end,
  },
}
