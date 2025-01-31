extends Node2D

# Configuration for the hair
@export var point_count : int = 4
@export var max_distance : float = 20.0
@export var circle_size : float = 40.0
@export var base_offset : Array[Vector2] = [Vector2(-1.0, 5.0), Vector2(-1.0, 5.0), Vector2(-0.5, 5.0), Vector2(-0.5, 2.5), Vector2(-0.5, 2.5), Vector2(-1.0, 10.0)] # Initial offset for the first point

# Hair points
var points = []
var offset = base_offset

func _ready():
	# Initialize points, starting with the root anchored to the head
	for i in range(point_count):
		points.append(Vector2.ZERO)

func _process(delta):
	# Update hair points positions
	_update_hair_positions()

	# Draw the hair
	queue_redraw()

func _update_hair_positions():
	var head_position = global_position
	var animated_sprite = get_node("../AnimatedSprite2D")
	if animated_sprite.flip_h:
		for i in range(point_count):
			offset[i].x = base_offset[i].x * -1
	else:
		for i in range(point_count):
			offset[i].x = base_offset[i].x

	# First point anchored to the head
	points[0] = head_position

	# Update each subsequent point
	for i in range(1, point_count):
		var target_position = points[i - 1] + offset[i - 1] * 3

		# Calculate direction to the target
		var direction = target_position - points[i]
		var distance = direction.length()

		# Constrain to max_distance
		#if distance > max_distance:
		#	direction = direction.normalized() * max_distance
		#	points[i] = points[i - 1] - direction + offset[i - 1]
		points[i] += (direction * 0.1) # Smooth follow effect

func _draw():
	var player = get_node("..")
	var color = Color(0.5, 0.2, 0.1) if player.dash == 1 else Color(0.16, 1, 1) if player.dash == 0 else Color(1, 0.4, 0.8)
	# Draw circles for each hair point
	var animated_sprite = get_node("../AnimatedSprite2D")
	if animated_sprite.flip_h:
		draw_circle(points[0] - global_position - Vector2(25, 80) + Vector2(-5, -5), circle_size, color)
		draw_circle(points[0] - global_position - Vector2(25, 80) + Vector2(-20, -5), circle_size, color)
		for i in range(point_count):
			var size = circle_size * (1 - i / (float(point_count) * 1.5)) # Gradually reduce size
			draw_circle(points[i] - global_position - Vector2(25, 80), size, color) # Example brownish color
	else:
		draw_circle(points[0] - global_position - Vector2(60, 80) + Vector2(5, -5), circle_size, color)
		draw_circle(points[0] - global_position - Vector2(60, 80) + Vector2(20, -5), circle_size, color)
		for i in range(point_count):
			var size = circle_size * (1 - i / (float(point_count) * 1.5)) # Gradually reduce size
			draw_circle(points[i] - global_position - Vector2(60, 80), size, color) # Example brownish color
