extends VBoxContainer

signal on_voltar

onready var som = $Som
onready var combo = $Idioma

func _ready():
	combo.add_item("PT-BR", Global.IDIOMA_PTBR)
	combo.add_item("ENG", Global.IDIOMA_ENG)
	
	if Global.get_habilita_som():
		som.pressed = true
		
	combo.select(combo.get_item_index(Global.get_idioma()))

func _on_Voltar_button_down():
	Global.set_habilita_som(som.pressed)
	
	Global.set_idioma(combo.get_selected_id())
	Global.atualiza_config()
	
	Audios.play_seleciona()
	
	emit_signal("on_voltar", self)

func _on_Idioma_button_down():
	Audios.play_seleciona()

func _on_Som_button_down():
	Audios.play_seleciona()
