extends EnemyBase


onready var parent: Node2D = get_parent()


func _process(delta):
	.shot_timer(delta)
	#._move_toward_player(delta)
	if shoot_timer >= shoot_interval:
		._shoot_burst()
		shoot_timer = 0.0


func _on_VisibilityNotifier2D_screen_entered():
	if parent:
		parent.ships_visible = true
	else:
		printerr("Problem with basic_enemy.gd")
