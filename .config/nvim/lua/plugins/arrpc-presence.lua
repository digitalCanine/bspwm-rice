return {
  "vyfor/cord.nvim",
  build = "./build || .\\build",
  event = "VeryLazy",
  opts = {
    editor = {
      client = "neovim",
      tooltip = "The only real IDE",
    },
    display = {
      theme = "default",
      flavor = "accent",
    },
  },
}
