local wezterm = require 'wezterm'

return {
  window_decorations = 'NONE',
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  use_ime = true,
  enable_tab_bar = false,
  audible_bell = 'Disabled',
  enable_wayland = true,
  font = wezterm.font('Hack Nerd Font Mono'),
  font_size = 9,

  colors = {
    background = '#282828',
    foreground = '#eeeeee',

    cursor_bg = '#ffffff',
    cursor_fg = '#000000',

    ansi = {
      '#282828',
      '#c8213d',
      '#169C51',
      '#DAAF19',
      '#2F90FE',
      '#C14ABE',
      '#48C6DB',
      '#CBCBCB',
    },
    brights = {
      '#505050',
      '#C7213D',
      '#1ef15f',
      '#FFE300',
      '#00aeff',
      '#FF40BE',
      '#48FFFF',
      '#ffffff',
    },
  },
}
