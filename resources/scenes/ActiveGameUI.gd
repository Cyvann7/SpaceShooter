extends CanvasLayer

onready var healthbarTex = $HealthBar/Texture
onready var healthbarLabel =  $HealthBar/Label
onready var enemyLeftLabel = $EnemyLeft
onready var world = get_parent().get_node("World")


func _physics_process(_delta):
	healthbarTex.value = (PlayerStats.pDict.Health/PlayerStats.pDict.MaxHealth) * 100
	healthbarLabel.text = str(round(PlayerStats.pDict.Health))
	
	if PlayerStats.pDict.Health/PlayerStats.pDict.MaxHealth < 0.2:
		  healthbarTex.tint_over = Color.red
	else: healthbarTex.tint_over = Color.white
	if is_instance_valid(world):
		setChildVisibility(true)
		var enemyleft = world.enemy_left()
		enemyLeftLabel.text = "Enemy Left: " + str(enemyleft)
	else:
		setChildVisibility(false)
		if not is_instance_valid(get_parent().get_node("MainMenu")):
			world = get_parent().get_node("World")

func setChildVisibility(b):
	healthbarLabel.visible = b
	healthbarTex.visible = b
	enemyLeftLabel.visible = b


