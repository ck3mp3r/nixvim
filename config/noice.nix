{ vimPlugins, ... }: {
  pkg = vimPlugins.noice-nvim;
  event = "VeryLazy";
  config = ''
    function()
      require'noice'.setup({
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
          inc_rename = false,
          lsp_doc_border = false,
        }
      })
    end
  '';

  dependencies = [
    vimPlugins.nui-nvim
    {
      pkg = vimPlugins.nvim-notify;
      opts = { background_colour = "#000000"; };
    }
  ];
}
