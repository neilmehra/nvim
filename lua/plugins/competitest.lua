return {
  {
    "xeluxee/competitest.nvim",
    commit = "c3cb0e2b0916a879c4d3dcb5737e6c046dd0afc5",
    ft = "cpp",
    dependencies = {
      {
        "MunifTanjim/nui.nvim",
      },
    },
    opts = {
      local_config_file_name = ".competitest.lua",

      floating_border = "solid",
      floating_border_highlight = "FloatBorder",
      picker_ui = {
        width = 0.2,
        height = 0.3,
        mappings = {
          focus_next = { "j", "<down>", "<Tab>" },
          focus_prev = { "k", "<up>", "<S-Tab>" },
          close = { "<esc>", "<C-c>", "q", "Q" },
          submit = { "<cr>" },
        },
      },
      editor_ui = {
        popup_width = 0.4,
        popup_height = 0.6,
        show_nu = true,
        show_rnu = false,
        normal_mode_mappings = {
          switch_window = { "<C-h>", "<C-l>", "<C-i>" },
          save_and_close = "<C-s>",
          cancel = { "q", "Q" },
        },
        insert_mode_mappings = {
          switch_window = { "<C-h>", "<C-l>", "<C-i>" },
          save_and_close = "<C-s>",
          cancel = "<C-q>",
        },
      },
      runner_ui = {
        interface = "split",
        selector_show_nu = false,
        selector_show_rnu = false,
        show_nu = true,
        show_rnu = false,
        mappings = {
          run_again = "R",
          run_all_again = "<C-r>",
          kill = "K",
          kill_all = "<C-k>",
          view_input = { "i", "I" },
          view_output = { "a", "A" },
          view_stdout = { "o", "O" },
          view_stderr = { "e", "E" },
          toggle_diff = { "d", "D" },
          close = { "q", "Q" },
        },
        viewer = {
          width = 0.5,
          height = 0.5,
          show_nu = true,
          show_rnu = false,
          close_mappings = { "q", "Q" },
        },
      },
      popup_ui = {
        total_width = 0.8,
        total_height = 0.8,
        layout = {
          { 4, "tc" },
          { 5, { { 1, "so" }, { 1, "si" } } },
          { 5, { { 1, "eo" }, { 1, "se" } } },
        },
      },
      split_ui = {
        position = "right",
        relative_to_editor = true,
        total_width = 0.3,
        vertical_layout = {
          { 1, "tc" },
          { 1, { { 1, "so" }, { 1, "eo" } } },
          { 1, { { 1, "si" }, { 1, "se" } } },
        },
        total_height = 0.4,
        horizontal_layout = {
          { 2, "tc" },
          { 3, { { 1, "so" }, { 1, "si" } } },
          { 3, { { 1, "eo" }, { 1, "se" } } },
        },
      },

      save_current_file = true,
      save_all_files = false,
      compile_directory = ".",
      compile_command = {
        c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
        cpp = { exec = "g++", args = { "-std=c++20", "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
        rust = { exec = "rustc", args = { "$(FNAME)" } },
        java = { exec = "javac", args = { "$(FNAME)" } },
      },
      running_directory = ".",
      run_command = {
        c = { exec = "./$(FNOEXT)" },
        cpp = { exec = "./$(FNOEXT)" },
        rust = { exec = "./$(FNOEXT)" },
        python = { exec = "python", args = { "$(FNAME)" } },
        java = { exec = "java", args = { "$(FNOEXT)" } },
      },
      multiple_testing = 0,
      maximum_time = 5000,
      output_compare_method = "squish",
      view_output_diff = true,

      testcases_directory = ".",
      testcases_use_single_file = true,
      testcases_auto_detect_storage = true,
      testcases_single_file_format = "$(FNOEXT).testcases",

      companion_port = 27121,
      receive_print_message = true,
    },
    keys = {
      {
        "<leader>ca",
        "<cmd>CompetiTest add_testcase<CR>",
        desc = "CompetiTest Add",
      },
      {
        "<leader>cr",
        "<cmd>CompetiTest run<CR>",
        desc = "CompetiTest Run",
      },
      {
        "<leader>ce",
        "<cmd>CompetiTest edit_testcase<CR>",
        desc = "CompetiTest Edit",
      },
      {
        "<leader>cd",
        "<cmd>CompetiTest delete_testcase<CR>",
        desc = "CompetiTest Receive Testcases",
      },
      {
        "<leader>ct",
        "<cmd>CompetiTest receive testcases<CR>",
        desc = "CompetiTest Receive Testcases",
      },
    },
  },
}
