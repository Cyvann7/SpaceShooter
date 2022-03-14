extends Node2D

export var speed = 750
var aoe_area = 30

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
		#take_hit(damage, is_there_dot, dot_time, dot_ticks, dot_damage_multiplier
		body.take_hit(1,10,true,10,10,10)
		
	$Particles2D.hide()
	$CollisionParticles.scale.x = aoe_area/4
	$CollisionParticles.scale.y = aoe_area/4
	$CollisionParticles.restart()
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()



