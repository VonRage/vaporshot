extends EnemyBase


onready var parent: Node2D = null
onready var siblings: Array
onready var sibling_count: int
onready var active: bool = false
onready var visibility_enabler: VisibilityEnabler2D = $VisibilityEnabler2D


func _ready():
	parent = get_parent()


func _physics_process(delta):
	.shot_timer(delta)
	if shoot_timer >= shoot_interval:
		._shoot_burst(3, 0.15, parent.rotation_degrees)
		shoot_timer = 0.0


func _on_VisibilityNotifier2D_screen_entered():
	siblings = parent.get_children()
	sibling_count = parent.get_child_count()
	if parent.is_in_group("enemy_group") and active == false:
		for i in sibling_count:
			siblings[i]._enable()
		parent.ships_visible = true
		active = true


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _enable() -> void:
	set_physics_process(true)
