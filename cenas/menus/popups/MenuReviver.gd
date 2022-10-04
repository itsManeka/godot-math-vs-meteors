extends PanelContainer

onready var admob = $AdMob
onready var botao_sim = $VBoxContainer/Sim
onready var botao_nao = $VBoxContainer/Nao

signal on_sim(ganhou_reward)
signal on_nao

var carregado = false
var clicou_sim = false

var assistiu = false

func _ready():
	if Global.is_android():
		admob.load_rewarded_video()

func _on_Sim_button_down():
	if !clicou_sim:
		clicou_sim = true
		botao_sim.disabled = true
		botao_nao.disabled = true
		
		Audios.play_seleciona()
		admob.show_rewarded_video()
	
func _on_Nao_button_down():
	Audios.play_seleciona()
	emit_signal("on_nao")
	hide()

func is_carregou():
	return carregado

func emite_sinal_sim():
	emit_signal("on_sim", assistiu)
	hide()

func _on_AdMob_rewarded_video_loaded():
	carregado = true

func _on_AdMob_rewarded_video_left_application():
	emite_sinal_sim()

func _on_AdMob_rewarded_video_closed():
	emite_sinal_sim()

func _on_AdMob_rewarded(currency, ammount):
	assistiu = true
