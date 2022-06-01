extends Control


var class_path = ""
var characters = [
	["res://resources/scenes/ClassScenes/Astronaut.tscn" ,"Commander","Rifle"      ,"Roll"],
	["res://resources/scenes/ClassScenes/Lewis.tscn"     ,"Hunter"   ,"Revolver"   ,"Blink"],
	["res://resources/scenes/ClassScenes/Ranger.tscn"    ,"Gunner"   ,"Machine Gun","Grenade"]
]


func _ready():
	choose_character(2)

func _on_StartGameButton_pressed():
	PlayerStats.ClassScene = load(class_path)
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://resources/scenes/ShipGameplay.tscn")

func choose_character(i):
	print(i)
	var class_chosen = characters[i]
	class_path = class_chosen[0]
	var classname = class_chosen[1]
	var classweapon = class_chosen[2]
	var classability = class_chosen[3]
	$Panel/UILabels/charactername.text = classname
	$Panel/UILabels/Statsbox/Ability/AbilityLabel.text = classability
	$Panel/UILabels/Statsbox/Weapon/WeaponLabel.text = classweapon
	$Panel/StartGameButton.disabled = false
	
func _on_Character1_pressed():
	choose_character(0)
func _on_Character2_pressed():
	choose_character(1)
func _on_Character3_pressed():
	choose_character(2)
