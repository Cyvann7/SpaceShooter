extends Node


var pTimeSpentInLevel = 0
var Score = 0
var Class = "Astronaut"
var ClassScene = load("res://resources/scenes/ClassScenes/Astronaut.tscn")

###PlayerStats
var pDict = {
	FireMod = 1,       #Fire Rate           (Multiplicative)
	SpeedMod = 1,      #Move Speed          (Multiplicative)
	DamageMod = 1,     #Bullet Damage       (Multiplicative)
	BulletAoEmod = 1,  #Bullet AOE          (Multiplicative)
	CritMod = 0,       #Bullet Crit Chance  (Additive)
	DotActive = false, #Bullet DOT          (Boolean )
	DotCoeffAdd = 0,   #DoT coefficient     (Additive)
	MaxHealth = 200.0,   #Max Health            (Multiplicative)
	Health = 10.0,
	AbilityMod = 1,
}

func _ready():
	pDict.Health = pDict.MaxHealth
###EnemyStats
var levelEnemyMod = 1
var EnemyUpgradeTime = 0 
var worldLevel = 0.0

func _physics_process(_delta):
	if EnemyUpgradeTime > 100 * (1+ (levelEnemyMod/2)):
		levelEnemyMod *= 1 + (worldLevel/10.0)
		EnemyUpgradeTime = 0
		Score += 1000

func healPlayer(h):
	pDict.Health += h
	if pDict.Health > pDict.MaxHealth:
		pDict.Health = pDict.MaxHealth

func damagePlayer(d):
	pDict.Health -= d
	if pDict.Health <= 0:
		killPlayer()

func killPlayer():
	get_tree().change_scene("res://resources/scenes/UI/PlayerDeath.tscn")








