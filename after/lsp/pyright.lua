return {
  before_init = function(_, config)
    local venv_python = config.root_dir and (config.root_dir .. "/.venv/bin/python")
    if venv_python and vim.uv.fs_stat(venv_python) then
      config.settings.python.pythonPath = venv_python
    end
  end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
}
