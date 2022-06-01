extends KinematicBody2D

export var move_speed = 250 
export var bullet = preload("res://resources/BulletTypes/Default.tscn")
export var grenade = preload("res://resources/BulletTypes/Grenade.tscn")
var actual_velocity
var fire_rate = 0.1
var currently_shooting = false
var currently_rolling =  false
export var roll_cd =    3
var roll_on_cd = false
var roll_time =  0.15
var roll_speed = 1000
var closest_enemy = null
onready var EnemyPointerArrow = $EnemyArrow


export(String, "Roll", "Blink", "Grenade") var ability

func _ready():
	move_speed *= PlayerStats.pDict.SpeedMod
	
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
	
	var world = get_parent()
	if world.enemy_left() < 10 and world.enemy_left() != 0:
		EnemyPointerArrow.show()
		
		if is_instance_valid(closest_enemy):
			EnemyPointerArrow.look_at(closest_enemy.global_position)
		else:
			var enemyleft = world.get_node("Enemy").get_children()
			closest_enemy = enemyleft[0]
			for enemy in enemyleft:
				if enemy.global_position.distance_to(global_position) < closest_enemy.global_position.distance_to(global_position):
					closest_enemy = enemy
		
		
	else: EnemyPointerArrow.hide()


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
	get_parent().add_child(b)
	b.transform = $Gun/GunMuzzle.global_transform
	b.rotation_degrees = $Gun.global_rotation_degrees
	if b.spread !=0:
		b.rotation_degrees += (b.spread - (randi()%b.spread)*2)
	currently_shooting = true
	yield(get_tree().create_timer(b.fire_rate/PlayerStats.pDict.FireMod), "timeout")
	currently_shooting = false
	
func roll():
	var non_roll_move_speed = move_speed
	currently_rolling = true
	move_speed = roll_speed
	yield(get_tree().create_timer(roll_time), "timeout")
	move_speed = non_roll_move_speed
	currently_rolling = false
	
func use_ability():
	if ability == "Roll":
		 roll()
	if ability == "Blink":
		 position = get_global_mouse_position()
	if ability == "Grenade":
			$Gun/GunMuzzle/Particles2D.restart()
			var g = grenade.instance()
			get_parent().add_child(g)
			g.transform = $Gun/GunMuzzle.global_transform
			g.rotation_degrees = $Gun.global_rotation_degrees
			currently_shooting = true
			yield(get_tree().create_timer(g.fire_rate/PlayerStats.pDict.FireMod), "timeout")
			currently_shooting = false






