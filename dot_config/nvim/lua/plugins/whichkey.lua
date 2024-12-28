return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    icons = {
      mappings = true,
      keys = {},
    },
    spec = {
      { '<leader>s', group = '[S]earch' },
    },
  },
}
