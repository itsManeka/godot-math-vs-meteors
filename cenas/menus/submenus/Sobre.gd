extends VBoxContainer

signal on_voltar

func _ready():
	pass

func _on_Voltar_button_down():
	Audios.play_seleciona()
	emit_signal("on_voltar", self)

func _on_Assets_button_down():
	Audios.play_seleciona()
	OS.shell_open("https://itsManeka.itch.io/assets-mvsm")

func _on_Email_button_down():
	Audios.play_seleciona()
	OS.shell_open("mailto:emanuel.ozoriodias@gmail.com")

func _on_IG_button_down():
	Audios.play_seleciona()
	OS.shell_open("https://www.instagram.com/emanuelozorio")

func _on_Twitter_button_down():
	Audios.play_seleciona()
	OS.shell_open("https://twitter.com/itsManeka")
