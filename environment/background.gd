extends Sprite

var player = null
export var parallax_factor = 0.1  # how much it moves (lower = more subtle)

func _ready():
	player = get_tree().get_nodes_in_group("player")[0] if get_tree().get_nodes_in_group("player").size() > 0 else null

func _process(delta):
	if player:
		# Move opposite to player (negative parallax)
		position = -player.global_position * parallax_factor
