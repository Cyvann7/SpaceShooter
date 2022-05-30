extends Camera2D


# offset the camera based on mouse position
func _physics_process(_delta):
	var mouse_pos = get_global_mouse_position()
	offset_h = (mouse_pos.x - global_position.x) / 960 # screen width halved
	offset_v = (mouse_pos.y - global_position.y) / 540 # screen height halved
	if Input.is_action_just_pressed("player_zoom"):
		zoom = Vector2(3,3)
	elif Input.is_action_just_released("player_zoom"):
		zoom = Vector2(0.8,0.8)


