extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	get_tree().change_scene("res://resources/scenes/ShipGameplay.tscn")

func _on_Tutorial_pressed():
	get_tree().change_scene("res://resources/scenes/Tutorial.tscn")

func _on_Options_pressed():
	get_tree().change_scene("res://resources/scenes/UI/Settings.tscn")

func _on_Quit_pressed():
	get_tree().quit()