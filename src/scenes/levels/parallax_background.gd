extends ParallaxBackground

@export var player: Player
@onready var forest = $ParallaxLayer/Sprite2D
@onready var moon = $ParallaxLayer/Sprite2D2

var transition_speed: float = 3.0
var forest_state: float = 1.0
var moon_state: float = 0.0

func _process(delta: float):
	player = get_node("../Player")
	if player:
		_update_target_alpha()
		_smooth_transition(delta)

func _update_target_alpha():
	if player.global_position.y > -450:
		forest_state = 1.0
		moon_state = 0.0
	else:
		forest_state = 0.0
		moon_state = 1.0

func _smooth_transition(delta: float):
	forest.modulate.a = lerp(forest.modulate.a, forest_state, delta * transition_speed)
	moon.modulate.a = lerp(moon.modulate.a, moon_state, delta * transition_speed)
