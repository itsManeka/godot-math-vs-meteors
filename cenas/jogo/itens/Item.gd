extends Node2D

onready var sprite = $Sprite
onready var main = get_parent()
onready var animacao_piscar = $Piscar
onready var som_apareceu_item = $ApareceuItem
onready var som_pegar_item = $PegarItem

var tipo_item = -1

var velocidade = Vector2(0, 0)
export var scale_selecionado = 0.7

var iniciou_animacao = false
var foi_pego = false

func _ready():
	hide()
	velocidade = main.get_velocidade_meteoros()
	
	if Global.get_habilita_som():
		som_apareceu_item.play()
	
func set_tipo_item(tipo):
	tipo_item = tipo

func inicia_animacao():
	iniciou_animacao = true
	if tipo_item == Global.ITEM_BOMBA_DE_SEMENTES:
		sprite.texture = load("res://recursos/saco_sementes.png")
	elif tipo_item == Global.ITEM_ENERGIA_ESCUDO:
		sprite.texture = load("res://recursos/escudo.png")
	elif tipo_item == Global.ITEM_MULTIPLICADOR_PONTOS_X2:
		sprite.texture = load("res://recursos/multpx2.png")
	elif tipo_item == Global.ITEM_MULTIPLICADOR_PONTOS_X3:
		sprite.texture = load("res://recursos/multpx3.png")
	show()

func _process(delta):
	if !iniciou_animacao:
		if tipo_item >= 0:
			inicia_animacao()

func _physics_process(delta):
	if main.pausado:
		return
		
	if !foi_pego:
		position += velocidade * delta
	
		if position.y + 20 > 320:
			queue_free()

func pegou_item():
	z_index = 0
	if Global.get_habilita_som():
		som_pegar_item.play()
		
	foi_pego = true
	scale = Vector2(scale_selecionado, scale_selecionado)
	animacao_piscar.play("piscar")
	set_position(Vector2(0, 0))

func _on_Touch_pressed():
	if main.pausado:
		return
		
	if !foi_pego:
		main.pega_item(self)
	else:
		main.usa_item(tipo_item)
		queue_free()
	
func get_tipo_item():
	return tipo_item

func is_item():
	return true
