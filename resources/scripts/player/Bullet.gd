extends Node2D

export var speed = 750
export var aoe_area = 1
#take_hit(d, crit_chance=0, dot=false, dottime=0,dotticks=0, dotcoeff=1):
export var damage = 10
export var crit_chance = 0.0
export var dot = false
export var dottime = 0.0
export var dotticks = 0
export var dotcoeff = 1.0



func _process(delta):
	if not $RayCast.is_colliding():
		position+= transform.x * speed * delta
	else: 
		position = $RayCast.get_collision_point() 
		position+= transform.x * speed/1000


func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	$CollisionShape2D.scale.x = aoe_area
	$CollisionShape2D.scale.y = aoe_area
	if body.has_method("take_hit"):
		#body takes 50 damage, with dot, over 2s, for 0.2*50 each time
		#take_hit(damage, crit,is_there_dot, dot_time, dot_ticks, dot_damage_multiplier
		body.take_hit(damage, crit_chance, dot, dottime,dotticks, dotcoeff)
	
	$Particles2D.hide()
	$CollisionParticles.scale.x = aoe_area/4
	$CollisionParticles.scale.y = aoe_area/4
	$CollisionParticles.restart()
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()



