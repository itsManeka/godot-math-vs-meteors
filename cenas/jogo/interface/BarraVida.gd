extends Control

signal fim_de_jogo

onready var barra = $Progresso
onready var valor = $Valor

var vida
export var total_vida = 100

func _ready():
	vida = total_vida

func set_total_vida(_valor):
	total_vida = valor
	
func aplica_dano(dano):
	vida -= dano
	vida = clamp(vida, 0, total_vida)
	define_progresso()
	if vida == 0:
		emit_signal("fim_de_jogo")
	
func restaura_vida(porcentagem):
	var _valor = float(total_vida) * (float(porcentagem) / 100.0)
	vida += _valor
	vida = clamp(vida, 0, total_vida)
	define_progresso()

func define_progresso():
	var progresso = ((vida * 100) / total_vida)
	barra.value = progresso
	valor.text = str(progresso) + "%"
