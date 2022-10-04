extends Control

var pre_configurar = preload("res://cenas/menus/submenus/Configurar.tscn")
var pre_creditos = preload("res://cenas/menus/submenus/Sobre.tscn")
var pre_como_jogar = preload("res://cenas/menus/submenus/comojogar/ComoJogar.tscn")
var pre_main_menu = preload("res://cenas/menus/submenus/MainMenu.tscn")

onready var menus = $Container/Menus
onready var animacao = $Animacao
onready var admob = $AdMob

var mostrou_baner = false

func _ready():
	var main = pre_main_menu.instance()
	
	menus.add_child(main)
	
	conecta_main(main)
	
	load_ads()
	
func load_ads():
	if Global.is_android():
		admob.load_banner()

func conecta_main(main):
	main.connect("on_jogar", self, "_on_jogar")
	main.connect("on_como_jogar", self, "_on_como_jogar")
	main.connect("on_configurar", self, "_on_configurar")
	main.connect("on_creditos", self, "_on_creditos")

func iniciar_jogo():
	get_tree().change_scene("res://cenas/jogo/Main.tscn")
	
func _on_jogar():
	admob.hide_banner()
	admob.queue_free()
	animacao.play("Iniciar")

func _on_como_jogar(menu):
	var como_jogar = pre_como_jogar.instance()
	
	menus.remove_child(menu)
	menu.queue_free()
	
	menus.add_child(como_jogar)
	
	como_jogar.connect("on_voltar", self, "_voltar_para_main")
	
func _on_configurar(menu):
	var configurar = pre_configurar.instance()
	
	menus.remove_child(menu)
	menu.queue_free()
	
	menus.add_child(configurar)
	
	configurar.connect("on_voltar", self, "_voltar_para_main")
	
func _on_creditos(menu):
	var creditos = pre_creditos.instance()
	
	menus.remove_child(menu)
	menu.queue_free()
	
	menus.add_child(creditos)
	
	creditos.connect("on_voltar", self, "_voltar_para_main")

func _voltar_para_main(current_menu):
	var main = pre_main_menu.instance()
	
	menus.remove_child(current_menu)
	current_menu.queue_free()
	
	menus.add_child(main)
	conecta_main(main)

func _on_AdMob_banner_loaded():
	if !mostrou_baner:
		mostrou_baner = true
		admob.show_banner()
