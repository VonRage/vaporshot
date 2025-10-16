extends Area2D

var velocity := Vector2.ZERO
export var lifetime := 3.0
var faction := "player"

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _process(delta):
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if faction == "player" and body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
	elif faction == "enemy" and body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
	if body.is_in_group("boss"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
	if body is TileMap:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
