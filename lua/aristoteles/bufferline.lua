-- Verifica se o plugin está instalado corretamente
local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
	return
end

-- Configuração básica do bufferline
bufferline.setup({
	options = {
		numbers = "none", -- Não mostra números, mas pode ser alterado para "ordinal" ou "buffer_id"
		indicator = { style = "icon", icon = "▎" }, -- Ícone de indicador de buffer ativo
		buffer_close_icon = "", -- Ícone de fechar buffer
		modified_icon = "●", -- Ícone de arquivo modificado
		close_icon = "", -- Ícone de fechar aba
		left_trunc_marker = "", -- Marcador para truncamento à esquerda
		right_trunc_marker = "", -- Marcador para truncamento à direita
		show_buffer_icons = true, -- Mostra ícones de buffer
		show_buffer_close_icons = true, -- Mostra ícones de fechar buffer
		show_close_icon = true, -- Mostra ícone de fechar linha de buffer
		separator_style = "thin", -- Estilo de separador: "slant", "thick", "thin"
		always_show_bufferline = true, -- Sempre mostrar o bufferline
		diagnostics = "nvim_lsp", -- Ativa ícones de diagnósticos do LSP
	},
})
