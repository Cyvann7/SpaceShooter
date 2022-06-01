extends Control

onready var labelcontainer = $Panel/LabelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	var Highscores = Global.highscores
	for score in Highscores:
		var hbox = HBoxContainer.new()
		var namelabel = Label.new()
		var scorelabel = Label.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		namelabel.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		scorelabel.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		namelabel.text = str(score[0])
		namelabel.align = Label.ALIGN_CENTER
		
		scorelabel.text = score[1]
		scorelabel.align = Label.ALIGN_CENTER
		
		hbox.add_child(namelabel)
		hbox.add_child(scorelabel)
		labelcontainer.add_child(hbox)


func _on_Back_pressed():
	get_tree().change_scene("res://resources/scenes/UI/MainMenu.tscn")

