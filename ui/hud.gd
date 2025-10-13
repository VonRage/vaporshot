extends Control


onready var score_label : Label = $ColorRect/CenterContainer/VBoxContainer/ScoreLabel
onready var time_label : Label = $ColorRect/CenterContainer/VBoxContainer/TimeLabel
onready var heart1: AnimatedSprite = $ColorRect2/CenterContainer/HBoxContainer/Control3/Heart1
onready var heart2: AnimatedSprite = $ColorRect2/CenterContainer/HBoxContainer/Control2/Heart2
onready var heart3: AnimatedSprite = $ColorRect2/CenterContainer/HBoxContainer/Control/Heart3
var score : int = 0
var time : float = 0.0
# Find a better way to do this. Setting it to 3 here and in player feels wrong
var current_health: int = 3


func _ready():
	time = 0.0
	score = 0

	GameStateManager.connect("score_changed", self, "_update_score")
	GameStateManager.connect("health_changed", self, "_update_health")


func _process(delta):
	time += delta
	var time_seconds : int = int(time)
	time_label.text = "%02d:%02d" % [time_seconds / 60, time_seconds % 60]


func _update_score(update) -> void:
	score = update
	score_label.text = str(score)


# I'm sure there's a better way to do this
func _update_health(updated_health):
	current_health = updated_health
	match current_health:
		3:
			heart1.play("live")
			heart2.play("live")
			heart3.play("live")
		2:
			heart1.play("dead")
			heart2.play("live")
			heart3.play("live")
		1:
			heart1.play("dead")
			heart2.play("dead")
			heart3.play("live")
		0:
			heart1.play("dead")
			heart2.play("dead")
			heart3.play("dead")
