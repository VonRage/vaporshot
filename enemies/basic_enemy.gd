extends EnemyBase


onready var parent: Node2D = null
onready var siblings: Array
onready var sibling_count: int
onready var active: bool = false
onready var visibility_enabler: VisibilityEnabler2D = $VisibilityEnabler2D


func _ready():
	parent = get_parent()
	siblings = parent.get_children()
	sibling_count = parent.get_child_count()

func _process(delta):
	.shot_timer(delta)
	#._move_toward_player(delta)
	if shoot_timer >= shoot_interval:
		._shoot_burst()
		shoot_timer = 0.0
	print("working")

func _on_VisibilityNotifier2D_screen_entered():
	if parent and active == false:
		for i in sibling_count:
			siblings[i]._enable()
		parent.ships_visible = true
		active = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _enable() -> void:
	set_process(true)
