extends Control


onready var start_button: Button = $Start_Button
onready var score_label : Label = $ColorRect/CenterContainer/VBoxContainer/ScoreLabel
onready var time_label : Label = $ColorRect/CenterContainer/VBoxContainer/TimeLabel
onready var heart1: AnimatedSprite = $ColorRect2/CenterContainer/HBoxContainer/Control3/Heart1
onready var heart2: AnimatedSprite = $ColorRect2/CenterContainer/HBoxContainer/Control2/Heart2
onready var heart3: AnimatedSprite = $ColorRect2/CenterContainer/HBoxContainer/Control/Heart3
onready var end_text: Label = $EndText
var score : int = 0
var time : float = 0.0
# Find a better way to do this. Setting it to 3 here and in player feels wrong
var current_health: int = 3
onready var boss_health_bar: ProgressBar = $BossHealthBar
var boss_health: int = 25


func _ready():
	time = 0.0
	score = 0

	GameStateManager.connect("score_changed", self, "_update_score")
	GameStateManager.connect("health_changed", self, "_update_health")
	GameStateManager.connect("boss_damaged", self, "_update_boss_healthbar")
	GameStateManager.connect("boss_on_screen", self, "_show_boss_healthbar")


func _process(delta):
	if get_tree().paused == false:
		time += delta
	var time_seconds : int = int(time)
	time_label.text = "%02d:%02d" % [time_seconds / 60, time_seconds % 60]
	if Input.is_action_just_pressed("shoot") and get_tree().paused == true:
		_on_Start_Button_pressed()


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


func _show_boss_healthbar():
	var tween = create_tween()
	tween.tween_property(boss_health_bar, "modulate:a", 0.8, 1)

func _update_boss_healthbar():
	boss_health_bar.value -= 1
	if boss_health_bar.value == 0:
		var tween = create_tween()
		tween.tween_property(boss_health_bar, "modulate:a", 0, 1)
		end_text.visible = true
		yield(get_tree().create_timer(10), "timeout")
		get_tree().quit()


func _on_Start_Button_pressed():
	get_tree().paused = false
	start_button.visible = false
	start_button.disabled = true

