return {
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- short, snappy trail — visible enough that flash/H/M/L/G feel intentional,
      -- not so much that small j/k movements draw attention
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      distance_stop_animating = 0.4,
      -- skip the noise: no smear across buffers/windows, no smear for tiny moves
      smear_between_buffers = false,
      smear_between_neighbor_lines = false,
      legacy_computing_symbols_support = true,
      -- subtle accent rather than full cursor color
      cursor_color = "none",
    },
  },
}
