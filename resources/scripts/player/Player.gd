extends KinematicBody2D

var move_speed = 250
var actual_velocity

var bullet = preload("res://resources/scenes/Bullet.tscn")


var fire_rate = 0.01
var currently_rolling = false
var currently_shooting = false
var roll_on_cd = false

var ability = "roll"
var roll_cd = 3
var rolltime = 0.1
var roll_coeff = 3

func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	
	var move_direction = Vector2.ZERO
	
	if Input.is_action_pressed("player_up"):   move_direction.y += -1
	if Input.is_action_pressed("player_down"): move_direction.y +=  1
	if Input.is_action_pressed("player_left"): move_direction.x += -1
	if Input.is_action_pressed("player_right"):move_direction.x +=  1
	
	if not currently_shooting and not currently_rolling:
		if Input.is_action_pressed("player_shoot"): shoot()
		
	move_direction = move_direction.normalized()
	actual_velocity = move_and_slide(move_direction*move_speed)
	
	look_at(get_global_mouse_position())
	
func _unhandled_input(event):
	if not currently_rolling and not roll_on_cd:
		if event.is_action_pressed("player_ability"):
			roll_on_cd = true
			$Player.modulate = Color(0.4,0.4,0.4)
			
			use_ability()
			
			yield(get_tree().create_timer(roll_cd), "timeout")
			$Player.modulate = Color(1,1,1)
			roll_on_cd = false

func shoot():
	$Gun/GunMuzzle/Particles2D.restart()
	var b = bullet.instance()
	owner.add_child(b)
	b.transform = $Gun/GunMuzzle.global_transform
	b.rotation_degrees = $Gun.global_rotation_degrees
	currently_shooting = true
	yield(get_tree().create_timer(fire_rate), "timeout")
	currently_shooting = false
	
func roll():
	currently_rolling = true
	move_speed = move_speed * roll_coeff
	yield(get_tree().create_timer(rolltime), "timeout")
	move_speed = move_speed / roll_coeff
	currently_rolling = false
	
func use_ability():
	if ability == "roll": roll()
	if ability == "blink": position = get_global_mouse_position()





