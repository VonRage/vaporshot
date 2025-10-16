extends Node
signal score_changed
signal health_changed
signal boss_damaged


# Yes, ik this is a terrible way to do this system.
export var score: int = 0
var player_health: int = 3


func set_score(points: int):
	score += points
	emit_signal("score_changed", score)


func health_changed(updated_health: int):
	player_health = updated_health
	emit_signal("health_changed", player_health)


func boss_damaged():
	emit_signal("boss_damaged")


func save():
	pass


func load():
	pass
