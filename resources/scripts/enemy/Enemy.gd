extends KinematicBody2D

var hp = 200
var floating_text_scene = preload("res://resources/scenes/floatingtext.tscn")
var crit = true

func take_hit(d, crit_chance=0, dot=false, dottime=0,dotticks=0, dotcoeff=1):
	if crit_chance != 0:
		if randi()%100 <= crit_chance:
			print("CRIT", crit_chance)
			crit = true
			d = d*2
	
	var float_text = floating_text_scene.instance()
	float_text.velocity = Vector2(rand_range(-50,50), rand_range(0,-50))
	if crit == true: float_text.modulate = Color(1,0,0)
	else: float_text.modulate = Color(1,1,1)
	
	float_text.text = str(d)
	
	add_child(float_text)
	
	hp-=d
	if hp<=0: queue_free()
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
	
