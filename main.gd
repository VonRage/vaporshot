extends Node2D

export var bg_scene : PackedScene
onready var bg : Node2D = null
var level_scene = preload("res://environment/level.tscn")
var hud_scene = preload("res://hud/hud.tscn")
export var player_scene : PackedScene
onready var player : KinematicBody2D = null
onready var player_spawn_point : Position2D = $PlayerSpawnPosition
export var enemy_scene : PackedScene
onready var enemy : KinematicBody2D = null
onready var enemy_spawn_point : Position2D = $EnemySpawnPosition


func _ready():
	spawn_background()
	spawn_level()
	spawn_hud()
	spawn_player()
	spawn_enemy()


func spawn_background():
	if bg:
		bg.queue_free()
	bg = bg_scene.instance()
	$EnvironmentBase.add_child(bg)


func spawn_level():
	var level

	if !level_scene:
		printerr("No level is loaded!")
		return 1
	level = level_scene.instance()
	$LevelBase.add_child(level)


func spawn_hud():
	var hud

	if !hud_scene:
		printerr("HUD is not loaded!")
		return 1
	hud = hud_scene.instance()
	$HUDBase.add_child(hud)


func spawn_player():
	if player:
		player.queue_free()
	player = player_scene.instance()
	$PlayerBase.add_child(player)
	player.global_position = player_spawn_point.global_position


func spawn_enemy():
	if enemy:
		enemy.queue_free()
	enemy = enemy_scene.instance()
	$EnemiesBase.add_child(enemy)
	enemy.global_position = enemy_spawn_point.global_position

