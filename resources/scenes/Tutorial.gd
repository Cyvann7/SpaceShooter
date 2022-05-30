extends Node2D

#Scenes Preload
var Room = preload("res://resources/scenes/room.tscn")
var Player = preload("res://resources/scenes/Player.tscn")
var Enemy = preload("res://resources/scenes/Enemy.tscn")


func _physics_process(delta):
	if enemy_left() == 0:
		$CanvasModulate.color = Color.black
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://resources/scenes/UI/MainMenu.tscn")
	
func _ready():
	pass

func enemy_left():
	return $Enemy.get_child_count()

