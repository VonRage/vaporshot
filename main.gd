extends Node2D


export var player_scene : PackedScene
onready var player : KinematicBody2D = null
onready var player_spawn_point : Position2D = $PlayerSpawnPosition
export var enemy_scene : PackedScene
onready var enemy : KinematicBody2D = null
onready var enemy_spawn_point : Position2D = $EnemySpawnPosition

# Game modes
enum Mode { SHIP, PILOT, BOSS }

var mode = Mode.SHIP


func _ready():
	print("Game started. Mode:", mode)
	spawn_player()
	spawn_enemy()


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


# --- Stubs for later ---
func enter_ship_mode():
	pass   # will handle ship spawn later


func enter_pilot_mode():
	pass   # will handle eject/pilot spawn later


func enter_boss_mode():
	pass   # will handle boss spawn later
