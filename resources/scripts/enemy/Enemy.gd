extends KinematicBody2D
export var move_speed = 150
export var hp = 70
export var damage = 20

var floating_text_scene = preload("res://resources/scenes/floatingtext.tscn")
var crit = false
var player = null
var attacking = false
onready var nav2D = get_parent().get_parent().get_node("Navigation2D")
var look_point = position

func _ready():
	move_speed *= PlayerStats.levelEnemyMod
	hp *= PlayerStats.levelEnemyMod
	damage *= PlayerStats.levelEnemyMod

###Damage 
func take_hit(d, crit_chance=0, dot=false, dottime=0,dotticks=0, dotcoeff=1):
	if crit_chance != 0:
		if randi()%100 <= crit_chance:
			crit = true
			d = d*2
	
	var float_text = floating_text_scene.instance()
	float_text.velocity = Vector2(rand_range(-50,50), rand_range(0,-50))
	if crit == true: float_text.modulate = Color(1,0,0)
	else: float_text.modulate = Color(1,1,1)
	float_text.rotation = 0
	float_text.text = str(d)
	float_text.position = self.global_position
	
	get_tree().get_root().add_child(float_text)

	hp-=d
	if hp<=0: 
		PlayerStats.Score += 50
		queue_free()

	modulate = Color(1,0.8,0.8)
	yield(get_tree().create_timer(0.1), "timeout")
	modulate = Color(1,1,1)
	if dot==true:
		start_dot(d,dottime,dotticks,dotcoeff)
	crit = false

func start_dot(d,dtime,dticks,dcoeff):
	dtime = dtime/dticks
	for _i in range(dticks):
		yield(get_tree().create_timer(dtime), "timeout")
		take_hit(d*dcoeff, 1)



###Moving
func _physics_process(delta):
	if not attacking and player and player.position.distance_to(self.position)>50:
		var path
		if not path:
			path = nav2D.get_simple_path(self.global_position, player.global_position)
		if path.size() < 6:
			move_along_path(path, (move_speed*delta))
			look_at(look_point)
		else:
			path = []
			yield(get_tree().create_timer(3), "timeout")

	elif not attacking and player and player.position.distance_to(self.position)<=50:
		look_at(look_point)
		attacking = true
		attack()
		yield(get_tree().create_timer(1), "timeout")
		attacking = false

	
func move_along_path(path, distance): #takes a path and a distance to move
	var start_point = position
	for _i in range(path.size()): # for every point along a path
		#set distance to the first point in the path as the distance we need to move
		var dis_to_nxt_point = start_point.distance_to(path[0])
		look_point = path[0]
		#if the distance we should move is smaller than the distance we need to move
		if distance <= dis_to_nxt_point and distance > 0.0:
			#move along that path 
			position = start_point.linear_interpolate(path[0], distance/dis_to_nxt_point)
			break
		#otherwise, if there is only 1 node left in that path, move to it.
		elif path.size() == 1 and distance > dis_to_nxt_point:
			position = path[0]
			set_process(false)
			break
		#reduce distance left by distance moved
		distance -= dis_to_nxt_point#
		#new current path point
		start_point = path[0]
		#pop the point
		path.remove(0)

func attack():
	move_speed*=2
	$AnimationPlayer.current_animation = "AttackWindup"
	yield(get_tree().create_timer(1), "timeout")
	for _i in range(5):
		if is_instance_valid(player):
			if player.position.distance_to(self.position)<=50:
				PlayerStats.damagePlayer(damage)
				break
			yield(get_tree().create_timer(0.2), "timeout")
		else:
			break
	move_speed*= 0.5
	

###Aggro Gain/Lost
func _on_AggroGainBox_body_entered(body):
	if body.name == "Player": 
		set_process(true)
		player = body
func _on_AggroLoseBox_body_exited(body):
	if body.name == "Player":
		player = null
		set_process(false)
