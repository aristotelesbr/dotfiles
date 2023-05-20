local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "aristoteles.lsp.mason"
require("aristoteles.lsp.handlers").setup()
require "aristoteles.lsp.null-ls"
