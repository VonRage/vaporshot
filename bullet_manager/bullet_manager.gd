### Global bullet spawner / manager.
### Handles creating bullets and assigning basic movement and lifetime.
extends Node2D


var bullet_scene = preload("res://bullet_manager/bullet.tscn")


func spawn_bullet(pos: Vector2, dir: Vector2, faction: String = "player", speed := 1250.0, lifetime := 3.0):
	var b = bullet_scene.instance()
	add_child(b)
	b.global_position = pos
	b.velocity = dir.normalized() * speed
	b.lifetime = lifetime
	b.faction = faction

	return b


func clear_all_bullets():
	for child in get_children():
		child.queue_free()
