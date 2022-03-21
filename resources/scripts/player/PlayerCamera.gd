extends Camera2D


# offset the camera based on mouse position
func _physics_process(_delta):
	var mouse_pos = get_global_mouse_position()
	offset_h = (mouse_pos.x - global_position.x) / 960 # screen width halved
	offset_v = (mouse_pos.y - global_position.y) / 540 # screen height halved
