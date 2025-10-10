extends EnemyBase


func _ready():
	var kamikaze = true


func _physics_process(delta):
	._move_toward_player(delta)
