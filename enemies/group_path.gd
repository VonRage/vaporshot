extends Path2D


onready var group: Node2D = null
onready var group_visible: bool = false
export var group_number = 0
export var speed: float = 200


func _ready():
	group = get_tree().get_nodes_in_group("enemy_group")[group_number]


func _process(delta):
	if group.ships_visible == true:
		$PathFollow2D.offset += speed * delta
		group.position = $PathFollow2D.global_position
