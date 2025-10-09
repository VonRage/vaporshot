extends EnemyBase


func _physics_process(delta):
	.shot_timer(delta)
	._move_toward_player(delta)
	if shoot_timer >= shoot_interval:
		._shoot_burst()
		shoot_timer = 0.0
