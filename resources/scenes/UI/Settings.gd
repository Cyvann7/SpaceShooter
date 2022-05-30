extends Control

onready var buttoncontainer = $Panel/KeybindsContainer
onready var buttonscript = load("res://resources/singleton/KeyButton.gd")

var keybinds
var buttons = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	keybinds = Global.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		
		label.text = key.split("_")[1]
		label.align = label.ALIGN_CENTER
		
		var button_value = keybinds[key]
		if button_value != null:
			button.text = OS.get_scancode_string(button_value)
		else:
			button.text = "Unassigned"
		button.set_script(buttonscript)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		
		hbox.add_child(label)
		hbox.add_child(button)
		buttoncontainer.add_child(hbox)
		
		buttons[key] = button

func change_bind(key, value):
	keybinds[key] = value
	
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			keybinds[k] = null
			buttons[k].text = "Unassigned"
			buttons[k].value = null

func _on_Back_pressed():
	get_tree().change_scene("res://resources/scenes/UI/MainMenu.tscn")

func _on_Save_pressed():
	Global.keybinds = keybinds.duplicate()
	Global.set_game_binds()
	Global.write_config()
	_on_Back_pressed()
