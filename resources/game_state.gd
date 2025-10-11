extends Node
signal score_changed
signal health_changed

export var score: int = 0
var player_health: int = 3

func set_score(points: int):
	score += points
	emit_signal("score_changed", score)


func health_changed(updated_health: int):
	player_health = updated_health
	emit_signal("health_changed", player_health)


func save():
	pass


func load():
	pass
