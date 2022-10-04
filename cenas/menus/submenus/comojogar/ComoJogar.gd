extends VBoxContainer

signal on_voltar

var menu_inicial
var pre_itens = preload("res://cenas/menus/submenus/comojogar/ComoJogarItens.tscn")

func _ready():
	menu_inicial = get_node("ComoJogarBasico")
	conecta_sinais(menu_inicial)

func conecta_sinais(menu):
	
	menu.connect("on_voltar", self, "_on_voltar")
	menu.connect("on_proximo", self, "_on_proximo")
	menu.connect("on_anterior", self, "_on_anterior")

func _on_voltar():
	emit_signal("on_voltar", self)
	
func _on_proximo(menu, nome):
	if nome == "basico":
		var itens = pre_itens.instance()
		remove_child(menu_inicial)
		add_child(itens)
		conecta_sinais(itens)

func _on_anterior(menu, nome):
	if nome == "itens":
		remove_child(menu)
		menu.queue_free()
		add_child(menu_inicial)
