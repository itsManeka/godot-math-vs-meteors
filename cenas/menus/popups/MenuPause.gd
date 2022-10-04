extends PanelContainer

signal on_continuar
signal on_menu

func _on_Continuar_button_down():
	Audios.play_seleciona()
	emit_signal("on_continuar")
	hide()

func _on_Menu_button_down():
	Audios.play_seleciona()
	emit_signal("on_menu")
	hide()
