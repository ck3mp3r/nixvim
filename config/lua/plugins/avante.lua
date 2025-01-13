local status, avante_provider = pcall(vim.api.nvim_get_var, "avante_provider")
if not status then
  avante_provider = "copilot"
end
return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      provider = avante_provider,
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      {
        "zbirenbaum/copilot.lua",
        opts = {},
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
