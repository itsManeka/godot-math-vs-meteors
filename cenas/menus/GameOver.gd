extends Control

onready var label_pontos = $Container/Menus/Pontos
onready var label_melhor = $Container/Menus/MelhorPontuacao
onready var admob = $AdMob
onready var animacao = $Animacao

var ads_carregado = false

func _ready():
	load_ads()
	
	label_pontos.text = str(Global.get_pontos()) + " pts"
	
	if Global.get_pontos() > Global.get_melhor_pontuacao():
		Global.set_melhor_pontuacao(Global.get_pontos())
		Global.atualiza_config()
		
	label_melhor.text = TranslationServer.translate("RECORD") + str(Global.get_melhor_pontuacao()) + " pts"
	
	pass
	
func load_ads():
	if Global.is_android():
		admob.load_interstitial()
		
func _on_MENU_button_down():
	Audios.play_seleciona()
	get_tree().change_scene("res://cenas/menus/MenuInicial.tscn")

func _on_TWITTER_button_down():
	Audios.play_seleciona()
	
	var link = ""
	
	var endpoint = "https://twitter.com/intent/tweet"
	var quebra = "%0D%0A"
	var espaco = "%20"
	var titulo = TranslationServer.translate("TITULO_JOGO")
	var texto = TranslationServer.translate("FIZ_TT") + " " + str(Global.get_pontos()) + " " + TranslationServer.translate("PONTOS_TT")
	var endereco = "https://play.google.com/store/apps/details?id=org.mnk.mathvsmeteor"
	var tags = "MathVSMeteors"
	
	link = endpoint + "?text=" + titulo + quebra + texto + quebra + endereco + quebra + "&hashtags=" + tags
	link.replace(" ", espaco)
	
	OS.shell_open(link)

func _on_JogarNovamente_button_down():
	Audios.play_seleciona()
	
	if Global.is_android() and ads_carregado:
		admob.show_interstitial()
	else:
		get_tree().change_scene("res://cenas/jogo/Main.tscn")

func _on_AdMob_interstitial_loaded():
	ads_carregado = true

func iniciar_jogo():
	get_tree().change_scene("res://cenas/jogo/Main.tscn")

func _on_AdMob_interstitial_closed():
	admob.queue_free()
	animacao.play("Iniciar")
