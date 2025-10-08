extends Node
signal score_changed

export var score := 0


func set_score(points: int):
    score += points
    emit_signal("score_changed", score)
    print("At GameState")


func save():
	pass


func load():
	pass