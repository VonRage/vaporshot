extends Control


onready var score_label : Label = $ColorRect/CenterContainer/VBoxContainer/ScoreLabel
onready var time_label : Label = $ColorRect/CenterContainer/VBoxContainer/TimeLabel
var score : int = 0
var time : float = 0.0


func _ready():
	time = 0.0
	score = 0

	GameStateManager.connect("score_changed", self, "_update_score")


func _process(delta):
	time += delta
	var time_seconds : int = int(time)
	time_label.text = "%02d:%02d" % [time_seconds / 60, time_seconds % 60]


func _update_score(update) -> void:
	print("At HUD")
	score = update
	score_label.text = str(score)
