extends Camera2D


var player: KinematicBody2D = null
export var offset_factor: float = 1.75
onready var camera_walls: Node2D = $CameraWalls


func _ready():
	player = get_parent().get_node("Player")


var tween = create_tween()

func _process(delta):
	self.offset.y = player.global_position.y / offset_factor
	camera_walls.position = self.position + self.offset
