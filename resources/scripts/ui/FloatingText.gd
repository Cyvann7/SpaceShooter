extends Position2D

onready var tween = $Tween

var velocity = Vector2(0,0)
var gravity = Vector2(0,0)
var mass = 0

var text setget set_text, get_text

func _ready():
	# color
	tween.interpolate_property(self,"modulate",
	Color(modulate.r, modulate.g, modulate.b, modulate.a),
	Color(modulate.r, modulate.g, modulate.b, 0.0),
	0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	
	# size
	# scale text up
	tween.interpolate_property(self, "scale",
		Vector2(0,0),
		Vector2(1.0,1.0),
		0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	#then scale text down
	tween.interpolate_property(self, "scale",
		Vector2(1.0,1.0),
		Vector2(0.4,0.4),
		1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.6)
	
	#now end effect and destroy
	tween.interpolate_callback(self,0.5,"remove")
	
	#start tween
	tween.start()
	
func _process(delta):
	velocity+= gravity * mass * delta
	position += velocity * delta

func set_text(new_text):
	$Label.text = str(new_text)

func get_text():
	return $Label.text
