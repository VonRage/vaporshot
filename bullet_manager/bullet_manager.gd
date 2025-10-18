### Global bullet spawner / manager.
### Handles creating bullets and assigning basic movement and lifetime.
extends Node2D


var bullet_scene = preload("res://bullet_manager/bullet.tscn")
#var laser_scene = preload("res://bullet_manager/laser.tscn")


func spawn_bullet(pos: Vector2, dir: Vector2, faction: String = "player", speed := 1250.0, lifetime := 3.0, rotation := 0):
	var b = bullet_scene.instance()
	add_child(b)
	b.global_position = pos
	b.velocity = dir.normalized() * speed
	b.lifetime = lifetime
	b.faction = faction
	b.rotation_degrees = rotation

	return b

# Spawns, then reparents to attach_parent
#func spawn_laser_attached(attach_parent: Node, local_dir: Vector2,
#							faction := "enemy", speed := 7000.0,
#							max_len := 1000.0, color := Color(1,1,1,1)):
#	var l = laser_scene.instance()
#	# place in world first so global transform is correct
#	get_tree().current_scene.add_child(l)
#
#	# set global pose from attach point
#	l.global_position = attach_parent.global_position
#	l.rotation = local_dir.angle()
#	l.fire(l.global_position, local_dir, faction, speed, max_len, color)
#
#	# reparent under the attach point and zero local offsets
#	l.get_parent().remove_child(l)
#	attach_parent.add_child(l)
#	l.position = Vector2.ZERO
#	l.rotation = local_dir.angle()   # keep aiming same direction in local space
#	return l


func clear_all_bullets():
	for child in get_children():
		child.queue_free()
