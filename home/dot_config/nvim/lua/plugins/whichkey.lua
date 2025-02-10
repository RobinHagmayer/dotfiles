return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  opts = {
    icons = {
      mappings = true,
      keys = {},
    },
    spec = {
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
    },
  },
}
