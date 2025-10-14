extends KinematicBody2D

export var bullet_scene : PackedScene
onready var bullet : Area2D = null
onready var bullet_spawn : Position2D = $BulletSpawnPoint
export var fire_cooldown := 0.20
var time_since_shot := 0.0
onready var health: int = 3
const I_FRAMES: float = 2.0
export var i_frames: float = 2.0

export var speed : float = 750
var velocity : Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	Logger.info("Player initialized")


func _physics_process(_delta):
	# Movement
	var v := Vector2(
		int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left")),
		int(Input.is_action_pressed("down"))  - int(Input.is_action_pressed("up"))
	)
	if v.length() > 0:
		v = v.normalized()
		
	move_and_slide(v * speed, Vector2.UP)


func _process(delta):
	# Shooting
	var right : Vector2 = Vector2(1, 0)
	time_since_shot += delta
	if Input.is_action_pressed("shoot") and time_since_shot >= fire_cooldown:
		BulletManager.spawn_bullet(bullet_spawn.global_position, right, "player")
		time_since_shot = 0.0
	i_frames += delta


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		take_damage()


func take_damage():
	if i_frames >= I_FRAMES:
		health -= 1
		if health > 0:
			GameStateManager.health_changed(health)
			i_frames = 0
		elif health <= 0:
			GameStateManager.health_changed(health)
			get_tree().reload_current_scene()
		else:
			Logger.error("Error with take_damage on player")