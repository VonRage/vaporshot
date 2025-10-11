extends EnemyBase


func _physics_process(delta):
	._move_toward_player_and_leave(delta)
