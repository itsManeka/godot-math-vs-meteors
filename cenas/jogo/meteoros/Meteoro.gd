extends Area2D

onready var label = $Label
onready var mira = $Mira
onready var main = get_parent()
onready var touch = $Touch
onready var meteoro = $Meteoro
onready var animacao_destruir = $AnimacaoDestruir
onready var som_explosao = $ExplosaoMeteoro
onready var fragmentos = $Fragmentos

var parar = false
var velocidade = Vector2(0, 0)

var valor
var is_operacao = false
var dano = 0

var selecionado = false

func _ready():
	fragmentos.hide()
	mira.hide()
	label.text = valor
	
	velocidade = main.get_velocidade_meteoros()

func destroi():
	if Global.get_habilita_som():
		som_explosao.play()
	animacao_destruir.play("destruir")

func _physics_process(delta):
	if main.pausado:
		return
		
	if !parar:
		position += velocidade * delta

func set_valor(_valor, _is_operacao):
	valor = _valor
	is_operacao = _is_operacao
	
	if !is_operacao and (valor != "0"):
		dano = int(valor)
	else:
		dano = 1

func remove_selecao():
	selecionado = false
	mira.hide()

func get_dano():
	return dano

func is_meteoro():
	return true

func _on_Touch_pressed():
	if main.pausado:
		return
		
	if !selecionado:
		if main.pode_selecionar(valor, is_operacao):
			Audios.play_seleciona()
			selecionado = true
			main.monta_calculo(self, valor, is_operacao)
			mira.show()
	else:
		main.limpa_jogada()

func destroi_elementos():
	parar = true
	
	fragmentos.show()
	fragmentos.play("explosao")
	
	label.hide()
	mira.hide()
	touch.hide()
	meteoro.hide()

func libera():
	queue_free()
	pass
