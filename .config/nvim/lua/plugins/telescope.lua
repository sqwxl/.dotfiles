return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = true,
    tag = "0.1.1",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(lazy, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("dap")
    end,
    opts = {
      defaults = {
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending"
      }
    }
  },
}
