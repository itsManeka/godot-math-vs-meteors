extends Node

var pontos

const IDIOMA_PTBR = 1
const IDIOMA_ENG = 2

const ITEM_CAFE_ESPACIAL = 0
const ITEM_BOMBA_DE_SEMENTES = 1
const ITEM_MULTIPLICADOR_PONTOS_X2 = 2
const ITEM_MULTIPLICADOR_PONTOS_X3 = 3
const ITEM_ENERGIA_ESCUDO = 4

var itens = [ITEM_CAFE_ESPACIAL, ITEM_BOMBA_DE_SEMENTES, ITEM_MULTIPLICADOR_PONTOS_X2,
			 ITEM_MULTIPLICADOR_PONTOS_X3, ITEM_ENERGIA_ESCUDO]

var config = ConfigFile.new()
var habilita_som = true
var idioma = IDIOMA_PTBR
var melhor_pontuacao = 0

const CAMINHO_CONFIG = "user://mvsmsettings.cfg"

func _ready():	
	randomize()
	init_conifg()
	
func is_android():
	return OS.get_name() == "Android"
	
func init_conifg():
	var err = config.load(CAMINHO_CONFIG)
	if err == OK:
		habilita_som = config.get_value("config", "som", true)
		idioma = config.get_value("config", "idioma", IDIOMA_PTBR)
		melhor_pontuacao = config.get_value("jogo", "melhor_pontucao", 0)
		
		set_locale(idioma)
	else:
		set_locale(IDIOMA_PTBR)

func set_locale(_idioma):
	if _idioma == IDIOMA_ENG:
		TranslationServer.set_locale("en")
	else:
		TranslationServer.set_locale("pt_BR")

func atualiza_config():
	config.set_value("config", "som", habilita_som)
	config.set_value("config", "idioma", idioma)
	config.set_value("jogo", "melhor_pontucao", melhor_pontuacao)
	config.save(CAMINHO_CONFIG)

func set_melhor_pontuacao(valor):
	melhor_pontuacao = valor
	
func get_melhor_pontuacao():
	return melhor_pontuacao

func set_idioma(_idioma):
	idioma = _idioma
	set_locale(idioma)

func get_idioma():
	return idioma

func set_habilita_som(habilita):
	habilita_som = habilita

func get_habilita_som():
	return habilita_som

func set_pontos(valor):
	pontos = valor

func soma_pontos(valor):
	pontos += valor

func get_pontos():
	return pontos

func reset():
	pontos = 0
