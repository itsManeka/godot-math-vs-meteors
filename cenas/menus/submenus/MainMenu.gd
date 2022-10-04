extends VBoxContainer

signal on_jogar
signal on_como_jogar
signal on_configurar
signal on_creditos

func _ready():
	pass

func _on_Jogar_button_down():
	Audios.play_seleciona()
	emit_signal("on_jogar")

func _on_Como_Jogar_button_down():
	Audios.play_seleciona()
	emit_signal("on_como_jogar", self)

func _on_Configurar_button_down():
	Audios.play_seleciona()
	emit_signal("on_configurar", self)

func _on_Sobre_button_down():
	Audios.play_seleciona()
	emit_signal("on_creditos", self)
