extends EnemyBase


func _process(delta):
	.shot_timer(delta)
	if shoot_timer >= shoot_interval:
		._shoot_aimed()
		shoot_timer = 0.0
