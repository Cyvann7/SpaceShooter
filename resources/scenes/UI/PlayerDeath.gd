extends Control


onready var charLabel  = $UILabels/Character/ClassValue
onready var timeLabel  = $UILabels/Time/TimeValue
onready var levelLabel = $UILabels/Level/LevelValue
onready var scoreLabel = $UILabels/Score/ScoreValue
onready var namebox = $UILabels/NameBox/TextEdit
onready var highscores = Global.highscores

func _ready():
	PlayerStats.Score += round(PlayerStats.pTimeSpentInLevel) * 10
	timeLabel.text = str(round(PlayerStats.pTimeSpentInLevel)) + "s"
	levelLabel.text = str(PlayerStats.worldLevel)
	scoreLabel.text = str(PlayerStats.Score)
	charLabel.text = str(PlayerStats.Class)

func _on_Back_Button_pressed():
	for score in range(highscores.size()):
		if highscores[score][0] < PlayerStats.Score:
			highscores.insert(score, [PlayerStats.Score,namebox.text])
			highscores.pop_back()
			break
	Global.save_highscores()
	get_tree().change_scene("res://resources/scenes/UI/MainMenu.tscn")
	
