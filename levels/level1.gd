extends Node2D

onready var player : Node2D = $Autoscroll
onready var path : PathFollow2D = $Path2D/PathFollow2D
export var speed: float = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	path.offset += speed * delta
	player.position = path.position
