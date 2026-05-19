return {
  cmd = {
    "clangd",
    "--background-index",
    "--background-index-priority=background",
    "--clang-tidy=false",
    "--completion-parse=auto",
    "--pch-storage=disk",
    "-j=1",
  },
}

