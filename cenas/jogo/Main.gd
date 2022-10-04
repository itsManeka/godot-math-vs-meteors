extends Node2D

onready var animacao_terra = $TerraBody/AnimacaoTerra
onready var label_calculo = $Interface/Calculo
onready var label_pontos = $Interface/Pontos
onready var btn_atirar = $Atirar
onready var animacao_atirar = $AnimacaoAtirar
onready var barra_vida = $Interface/BarraVida
onready var position_item_1 = $NodeComando/Item1
onready var position_item_2 = $NodeComando/Item2
onready var position_item_3 = $NodeComando/Item3
onready var position_item_4 = $NodeComando/Item4
onready var escudo = $Escudo
onready var timer_mulp = $TimerMultp
onready var label_multp = $Interface/Multp
onready var expression = Expression.new()
onready var som_colisao = $ColidirMeteoro
onready var som_usar_item = $UsarItem
onready var som_atirar = $SomAtirar
onready var som_explodir_terra = $ExplodirTerra
onready var musica = $Musica
onready var menu_pause = $MenuPause
onready var menu_ver_video = $MenuReviver

var pre_meteoro = preload("res://cenas/jogo/meteoros/Meteoro.tscn")
var pre_item = preload("res://cenas/jogo/itens/Item.tscn")

export var base_chances_pra_um_item = 4
export var diminuir_dificuldade_item_por = 2
var chances_para_um_item = base_chances_pra_um_item

var operacoes = ["+", "-"]

var igualou = false
var ultimo_valor_is_operacao = false
var valor_antes_igual = ""
var valor_depois_igual = ""
var multiplicador = 1
var pontos = 0
var multiplicador_item = 1

var pausado = false
var pode_gerar = true
var ultima_posicao_gerada = 0

var rodadas = 1

var meteoros_selecionados = []

var velocidade_meteoros = Vector2(0, 0)
export var velocidade_inicial_meteoros = 6
export var step_velocidade_meteoros = 1
export var max_velocidade_meteoros = 30

export var max_numeros_por_operacoes = 2
var numeros_por_operacoes = 0

var escudo_ativado = false

var ja_usou_video = false

func _ready():
	if Global.get_habilita_som():
		musica.play()
	
	btn_atirar.text = "="
	
	Global.reset()
	
	label_multp.hide()
	menu_pause.hide()
	escudo.set_main(self)
	
	velocidade_meteoros.y = velocidade_inicial_meteoros
	
	gerar_novo_meteoro()

func habilita_igual(habilita):
	if btn_atirar.text == "=":
		btn_atirar.disabled = !habilita
		if habilita:
			animacao_atirar.play("piscar")

func add_operacoes_dificeis():
	operacoes.append("*")
	operacoes.append("/")

func get_velocidade_meteoros():
	return velocidade_meteoros

func aumenta_velocidade_meteoros():
	rodadas += 1
	
	if rodadas == 4:
		add_operacoes_dificeis()
	
	var velocidade = 0
	
	velocidade = velocidade_meteoros.y + step_velocidade_meteoros
	velocidade = clamp(velocidade, velocidade_inicial_meteoros, max_velocidade_meteoros)
	
	velocidade_meteoros.y = velocidade
	
func reduz_velocidade_meteoros(_multiplicador = 1):
	var velocidade = 0
	
	velocidade = velocidade_meteoros.y - (step_velocidade_meteoros * _multiplicador)
	velocidade = clamp(velocidade, velocidade_inicial_meteoros, max_velocidade_meteoros)
	
	velocidade_meteoros.y = velocidade

func monta_calculo(meteoro, valor, is_operacao):
	habilita_igual(!is_operacao)
	
	if is_operacao:
		if ["+", "-"].has(valor):
			multiplicador += 1
		else:
			multiplicador += 2
		
		chances_para_um_item = base_chances_pra_um_item - diminuir_dificuldade_item_por
	else:
		pontos += int(valor)
	
	if igualou:
		habilita_atirar()
		valor_depois_igual += valor
	else:
		valor_antes_igual += valor
			
	ultimo_valor_is_operacao = is_operacao
	
	label_calculo.text = valor_antes_igual
	if igualou:
		label_calculo.text += "=" + valor_depois_igual
		
	meteoros_selecionados.append(meteoro)

func set_texto_atirar():
	if btn_atirar.text == "=":
		btn_atirar.text = TranslationServer.translate("ATIRAR")

func habilita_atirar():
	btn_atirar.disabled = false
	animacao_atirar.play("piscar")

func desabilita_atirar():
	btn_atirar.disabled = true
	animacao_atirar.play("parar")

func pode_selecionar(valor, is_operacao) -> bool:
	if valor_antes_igual == "" and is_operacao:
		return false
		
	if ultimo_valor_is_operacao and is_operacao:
		return false
	
	if igualou and valor_depois_igual == "" and is_operacao:
		return false
		
	return true

func gera_meteoro(meteoro, valor, is_operacao):
	meteoro.set_valor(valor, is_operacao)
	
	if ultima_posicao_gerada == 0:
		meteoro.position = Vector2(rand_range(16, 166), -14)
	else:
		if ultima_posicao_gerada <= 90:
			meteoro.position = Vector2(rand_range(ultima_posicao_gerada + 30, 166), -14)
		else:
			meteoro.position = Vector2(rand_range(16, ultima_posicao_gerada - 30), -14)
	
	ultima_posicao_gerada = meteoro.position.x
	
	call_deferred("add_child", meteoro)

func gerar_item_aleatorio(pos):
	var item = pre_item.instance()
	item.position = pos
	item.set_tipo_item(Global.itens[rand_range(0, Global.itens.size())])
	add_child(item)

func gerar_meteoro_operacoes():
	var valor = ""
	
	var meteoro = pre_meteoro.instance()
	
	valor = operacoes[rand_range(0, operacoes.size())]
	
	gera_meteoro(meteoro, valor, true)
	
func gerar_meteoro_numeros():
	var valor = ""
	
	var meteoro = pre_meteoro.instance()
	valor = str(randi()%10)

	gera_meteoro(meteoro, valor, false)
	
func _on_Atirar_button_down():
	if pausado:
		return
	
	if igualou:
		atira()
	else:
		Audios.play_seleciona()
		igualou = true
		set_texto_atirar()
		label_calculo.text += "="
		desabilita_atirar()
		
func atira():
	pode_gerar = false
	
	if Global.get_habilita_som():
		som_atirar.play()
	
	var valor1 = 0
	var valor2 = 0
	var calculo_correto = false
	
	var error
	error = expression.parse(valor_antes_igual, [])
	if error!= OK:
		print(expression.get_error_text())
	valor1 = expression.execute([], null, true)
	
	error = expression.parse(valor_depois_igual, [])
	if error!= OK:
		print(expression.get_error_text())
	valor2 = expression.execute([], null, true)
	
	calculo_correto = valor1 == valor2
	
	if calculo_correto:
		aplica_pontos(pontos * multiplicador * multiplicador_item)
		for m in get_children():
			if m.has_method("is_meteoro"):
				m.destroi()
				
		aumenta_velocidade_meteoros()
		
		if randi()%chances_para_um_item == 0:
			gerar_item_aleatorio(Vector2(90, 160))
	else:
		remove_selecoes()
	
	limpa_variaveis()
	
	pode_gerar = true
	gerar_novo_meteoro()

func remove_selecoes():
	for m in meteoros_selecionados:
		m.remove_selecao()

func limpa_jogada():
	remove_selecoes()
	limpa_variaveis()

func limpa_variaveis():
	desabilita_atirar()
	chances_para_um_item = base_chances_pra_um_item
	multiplicador = 1
	pontos = 0
	meteoros_selecionados.clear()
	igualou = false
	ultimo_valor_is_operacao = false
	valor_antes_igual = ""
	valor_depois_igual = ""
	label_calculo.text = ""
	btn_atirar.text = "="
	habilita_igual(false)

func aplica_pontos(valor):
	Global.soma_pontos(valor)
	label_pontos.text = str(Global.get_pontos()) + " pts"

func pega_item(item):
	var pegou = false
	
	if position_item_1.get_child_count() == 0:
		remove_child(item)
		position_item_1.add_child(item)
		pegou = true
	elif position_item_2.get_child_count() == 0:
		remove_child(item)
		position_item_2.add_child(item)
		pegou = true
	elif position_item_3.get_child_count() == 0:
		remove_child(item)
		position_item_3.add_child(item)
		pegou = true
	elif position_item_4.get_child_count() == 0:
		remove_child(item)
		position_item_4.add_child(item)
		pegou = true
	
	if pegou:
		item.pegou_item()

func usa_item(tipo_item):
	if Global.get_habilita_som():
		som_usar_item.play()
	
	if tipo_item == Global.ITEM_CAFE_ESPACIAL:
		reduz_velocidade_meteoros(2)
	elif tipo_item == Global.ITEM_BOMBA_DE_SEMENTES:
		barra_vida.restaura_vida(10)
	elif tipo_item == Global.ITEM_ENERGIA_ESCUDO:
		escudo.ativar_escudo()
	elif tipo_item == Global.ITEM_MULTIPLICADOR_PONTOS_X2:
		multiplicador_item = 2
		label_multp.text = "X2"
		label_multp.show()
		timer_mulp.start(10)
	elif tipo_item == Global.ITEM_MULTIPLICADOR_PONTOS_X3:
		multiplicador_item = 3
		label_multp.text = "X3"
		label_multp.show()
		timer_mulp.start(10)

func _on_TerraBody_area_entered(area):
	if Global.get_habilita_som():
		som_colisao.play()
	
	if area.selecionado:
		limpa_jogada()
	
	if !escudo_ativado:
		barra_vida.aplica_dano(area.get_dano())
		if pode_gerar:
			animacao_terra.play("shake")
		
	area.destroi()

func gerar_novo_meteoro():
	if !pode_gerar:
		return
	
	numeros_por_operacoes += 1
	
	if numeros_por_operacoes > max_numeros_por_operacoes:
		numeros_por_operacoes = 0
		gerar_meteoro_operacoes()
	else:
		gerar_meteoro_numeros()
	
func _on_TimerMultp_timeout():
	label_multp.hide()
	multiplicador_item = 1

func _on_NovoMeteoro_area_entered(area):
	if area.has_method("is_meteoro"):
		gerar_novo_meteoro()

func _on_BarraVida_fim_de_jogo():
	pode_gerar = false
	
	for m in get_children():
		if m.has_method("is_meteoro"):
			m.destroi()
			
	limpa_jogada()
	
	if not ja_usou_video and menu_ver_video.is_carregou() and Global.is_android():
		pausar(true)
		menu_ver_video.show()
	else:
		fim_de_jogo()
	
func fim_de_jogo():
	if Global.get_habilita_som():
		som_explodir_terra.play()
	
	animacao_terra.play("Fim de jogo")

func muda_tela_game_over():
	get_tree().change_scene("res://cenas/menus/GameOver.tscn")

func _on_Pausar_button_down():
	pausar(true)
	Audios.play_seleciona()
	menu_pause.show()

func pausar(condicao):
	if condicao:
		pausado = true
		timer_mulp.paused = true
		escudo.pausar(true)
	else:
		pausado = false
		timer_mulp.paused = false
		escudo.pausar(false)

func _on_MenuPause_on_continuar():
	pausar(false)

func _on_MenuPause_on_menu():
	get_tree().change_scene("res://cenas/menus/MenuInicial.tscn")

func _on_MenuReviver_on_nao():
	ja_usou_video = true
	pausar(false)
	fim_de_jogo()

func _on_MenuReviver_on_sim(ganhou_reward):
	ja_usou_video = true
	pausar(false)
	
	if ganhou_reward:
		barra_vida.restaura_vida(50)
		pode_gerar = true
		gerar_novo_meteoro()
	else:
		fim_de_jogo()
