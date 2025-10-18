extends EnemyBase


onready var parent: Node2D = null
onready var siblings: Array
onready var sibling_count: int
onready var active: bool = false
onready var visibility_enabler: VisibilityEnabler2D = $VisibilityEnabler2D


func _ready():
	parent = get_parent() if get_parent() is Node2D else null


func _physics_process(delta):
	.shot_timer(delta)
	if shoot_timer >= shoot_interval:
		._shoot_spread()
		shoot_timer = 0.0
	if active == false:
		active = true


func _on_VisibilityNotifier2D_screen_entered():
	if parent:
		siblings = parent.get_children()
		sibling_count = parent.get_child_count()
		set_physics_process(true)
		parent.ships_visible = true
		## NO IDEA WHY THIS WON'T WORK ON THIS ENEMY BUT IT'S FINE ON V ENEMY!!!
#		if parent.is_in_group("enemy_group") and active == false:
#			for i in sibling_count:
#				siblings[i]._enable()
#			parent.ships_visible = true
#			active = true


func _on_VisibilityNotifier2D_screen_exited():
	if active == true:
		queue_free()


func _enable() -> void:
	set_physics_process(true)
