extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func reset():
	#Reset player stats
	PlayerStats.pDict = {
	FireMod = 1,       #Fire Rate           (Multiplicative)
	SpeedMod = 1,      #Move Speed          (Multiplicative)
	DamageMod = 1,     #Bullet Damage       (Multiplicative)
	BulletAoEmod = 1,  #Bullet AOE          (Multiplicative)
	CritMod = 0,       #Bullet Crit Chance  (Additive)
	DotActive = false, #Bullet DOT          (Boolean )
	DotCoeffAdd = 0,   #DoT coefficient     (Additive)
	MaxHealth = 200.0,   #Max Health            (Multiplicative)
	Health = 10.0
	}
	PlayerStats.levelEnemyMod = 1
	PlayerStats.EnemyUpgradeTime = 0 
	PlayerStats.worldLevel = 0.0
	PlayerStats.pTimeSpentInLevel = 0
	PlayerStats.Score = 0


func _on_Start_pressed():
	reset()
	get_tree().change_scene("res://resources/scenes/UI/CharacterSelect.tscn")
func _on_Tutorial_pressed():
	get_tree().change_scene("res://resources/scenes/Tutorial.tscn")
func _on_Options_pressed():
	get_tree().change_scene("res://resources/scenes/UI/Settings.tscn")
func _on_Leaderboard_pressed():
	get_tree().change_scene("res://resources/scenes/UI/Leaderboard.tscn")
func _on_Quit_pressed():
	get_tree().quit()

