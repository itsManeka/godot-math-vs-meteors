extends Node2D

var main

onready var timer = $Timer

func _ready():
	hide()

func set_main(_main):
	main = _main

func ativar_escudo():
	main.escudo_ativado = true
	show()
	
	timer.start(10)

func _on_Timer_timeout():
	main.escudo_ativado = false
	hide()

func pausar(condicao):
	timer.paused = condicao
