extends Area2D

enum Faction { PLAYER, ENEMY }

export var speed := 400.0
export var lifetime := 3.0
var velocity := Vector2.ZERO
var faction : enum = Faction.PLAYER   # default

func _process(delta):
	position += velocity * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
