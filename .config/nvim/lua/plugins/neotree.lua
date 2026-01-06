return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right",
        width = 25,
        mappings = {
          ["`"] = "close_window", -- leave neotree

          ["."] = "navigate_up", -- go to parent dir
          ["d"] = "delete",
          ["c"] = "copy_to_clipboard",
          ["v"] = "paste_from_clipboard",

          ["n"] = "add", -- new file
          ["f"] = "add_directory", -- new folder
        },
      },

      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,

        filtered_items = {
          visible = true, -- show hidden files
        },
      },
    },
  },
}
