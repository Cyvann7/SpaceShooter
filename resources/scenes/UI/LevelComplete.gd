extends Control



#FireMod = 1,       #Fire Rate           (Multiplicative)
#SpeedMod = 1,      #Move Speed          (Multiplicative)
#DamageMod = 1,     #Bullet Damage       (Multiplicative)
#BulletAoEmod = 1,  #Bullet AOE          (Multiplicative)
#CritMod = 0,       #Bullet Crit Chance  (Additive)
#DotActive = false, #Bullet DOT          (Boolean )
#DotCoeffAdd = 0,   #DoT coefficient     (Additive)
#MaxHealth = 200.0, #Max Health          (Additive)
#Health = 10.0


onready var possibleUpgrades = [
	#Stat, Increase, Texture
	["MaxHealth"   , 1.25   , load("res://resources/assets/ui/Upgrades/HitPointsUp.png"   )],
	["DamageMod"   , 10     , load("res://resources/assets/ui/Upgrades/DamageUp.png"      )],
	["FireMod"     , 1.4    , load("res://resources/assets/ui/Upgrades/RateOfFireUp.png"  )],
	["SpeedMod"    , 1.2    , load("res://resources/assets/ui/Upgrades/MoveSpeedUp.png"   )],
	["BulletAoEmod", 3      , load("res://resources/assets/ui/Upgrades/FragmentUp.png"    )],
	["CritMod"     , 10     , load("res://resources/assets/ui/Upgrades/CritChanceUp.png"  )],
	["AbilityMod"  , 1.4    , load("res://resources/assets/ui/Upgrades/AbilityCDUp.png"   )],
]

var additiveUpgrades = [
	"DotCoeffAdd",
	"CritMod",
	"DamageMod",
]
var multiplicativeUpgrades = [
	"FireMod",
	"SpeedMod",
	"BulletAeEmod",
	"MaxHealth",
	"AbilityMod"
]

var chosen_upgrades = []
var upgradeindex = -1
onready var labels = $UILabels

func _ready():
	choose_upgrades()
	print(chosen_upgrades)
	labels.get_node("TimeValue").text = str(PlayerStats.pTimeSpentInLevel)
	labels.get_node("LevelValue").text = str(PlayerStats.worldLevel)

func select_upgrade(choice):
	var chosen_upgrade = chosen_upgrades[choice]
	var upgrade_name = chosen_upgrade[0]
	var upgrade_addition = chosen_upgrade[1]
	
	if upgrade_name in additiveUpgrades:
		PlayerStats.pDict[upgrade_name] += upgrade_addition
	elif upgrade_name in multiplicativeUpgrades:
		PlayerStats.pDict[upgrade_name] *= upgrade_addition
	
	

func choose_upgrades():
	randomize()
	for i in range(3):
		var chosen_index = randi()%possibleUpgrades.size()
		var chosen = possibleUpgrades[chosen_index]
		while chosen in chosen_upgrades:
			chosen_index = randi()%possibleUpgrades.size()
			chosen = possibleUpgrades[chosen_index]
		chosen_upgrades.append(chosen)
		get_node("Upgrades").get_child(i).texture_normal = chosen[2]

func _on_Upgrade1_pressed():
	upgradeindex = 0
	$Upgrades/Upgrade2.pressed = false
	$Upgrades/Upgrade3.pressed = false
	$Upgrades/Upgrade2.modulate = Color(0.4,0.4,0.4)
	$Upgrades/Upgrade3.modulate = Color(0.4,0.4,0.4)
	$Upgrades/Upgrade1.modulate = Color(1,1,1)
	$NextLevelButton.disabled = false
func _on_Upgrade2_pressed():
	upgradeindex = 1
	$Upgrades/Upgrade1.pressed = false
	$Upgrades/Upgrade3.pressed = false
	$Upgrades/Upgrade1.modulate = Color(0.4,0.4,0.4)
	$Upgrades/Upgrade3.modulate = Color(0.4,0.4,0.4)
	$Upgrades/Upgrade2.modulate = Color(1,1,1)
	$NextLevelButton.disabled = false
func _on_Upgrade3_pressed():
	upgradeindex = 2
	$Upgrades/Upgrade1.pressed = false
	$Upgrades/Upgrade2.pressed = false
	$Upgrades/Upgrade2.modulate = Color(0.4,0.4,0.4)
	$Upgrades/Upgrade1.modulate = Color(0.4,0.4,0.4)
	$Upgrades/Upgrade3.modulate = Color(1,1,1)
	$NextLevelButton.disabled = false
func _on_NextLevelButton_pressed():
	select_upgrade(upgradeindex)
	get_tree().change_scene("res://resources/scenes/ShipGameplay.tscn")
