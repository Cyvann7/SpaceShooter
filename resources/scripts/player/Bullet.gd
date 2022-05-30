extends Node2D

export var speed = 750
export var aoe_area = 1.0
export var damage = 10
export var crit_chance = 0.0
export var dot = false
export var dottime = 5
export var dotticks = 5
export var dotcoeff = 1.0
export var fire_rate = 1.0
export var spread = 10

func _ready():
	aoe_area = aoe_area * PlayerStats.pDict.BulletAoEmod
	damage = damage * PlayerStats.pDict.DamageMod
	crit_chance = crit_chance + PlayerStats.pDict.CritMod
	dot = ((int(dot) + int(PlayerStats.pDict.DotActive)) != 0)
	dotcoeff = 1.0 + PlayerStats.pDict.DotCoeffAdd



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
		body.take_hit(damage, crit_chance, dot, dottime,dotticks, dotcoeff)
	
	$Particles2D.hide()
	$CollisionParticles.scale.x = aoe_area/4
	$CollisionParticles.scale.y = aoe_area/4
	$CollisionParticles.restart()
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()



