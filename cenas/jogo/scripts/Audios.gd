extends Node

onready var seleciona = $Seleciona

func play_seleciona():
	if Global.get_habilita_som():
		seleciona.play()
