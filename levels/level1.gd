extends Node2D


onready var path: Node2D = $AutoscrollPath/PathFollow2D
export var speed: float = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	path.offset += speed * delta
