extends VBoxContainer

signal on_anterior
signal on_voltar
signal on_proximo

export var nome_menu = ""

func _ready():
	print(nome_menu)
	if nome_menu != "basico":
		$HBoxContainer/Anteior.disabled = false
	if nome_menu != "itens":
		$HBoxContainer/Proximo.disabled = false

func _on_Voltar_button_down():
	Audios.play_seleciona()
	emit_signal("on_voltar")

func _on_Proximo_button_down():
	Audios.play_seleciona()
	emit_signal("on_proximo", self, nome_menu)

func _on_Anteior_button_down():
	Audios.play_seleciona()
	emit_signal("on_anterior", self, nome_menu)
