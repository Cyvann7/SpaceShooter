extends Node

var configfile
var configfilepath = "res://settings.ini"
var highscorefilepath = "res://Highscores.txt"

var keybinds = {}
var highscores = []


func _ready():
	configfile = ConfigFile.new()
	if configfile.load(configfilepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds",key)
			keybinds[key] = key_value
			
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
	else:
		print("CONFIG FILE NOT FOUND")
	set_game_binds()
	load_highscores()
	save_highscores()

func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		var actionlist = InputMap.get_action_list(key)
		if !actionlist.empty():
			InputMap.action_erase_event(key, actionlist[0])
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key,new_key)#

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds",key,key_value)
		else:
			configfile.set_value("keybinds",key,"")
	configfile.save(configfilepath)

func load_highscores():
	var HighscoreFile = File.new()
	HighscoreFile.open(highscorefilepath, File.READ)
	print("LOADING FILE")
	for _i in range(10):
		var line = HighscoreFile.get_line()
		var scorename = line.split(",")
		print(scorename)
		var score = scorename[0]
		var pname = scorename[1]
		highscores.append([int(score), pname])
	print("FILE LOADED")
	print("HIGH SCORES: \n",highscores)

func save_highscores():
	#Delete File
	var dir = Directory.new()
	dir.remove(highscorefilepath)
	#Make new one
	var HighscoreFile = File.new()
	HighscoreFile.open(highscorefilepath, File.WRITE_READ)
	for score in highscores:
		HighscoreFile.seek_end()
		var content = str(score[0]) + "," + score[1] + "\n"
		HighscoreFile.store_string(content)




