extends Area2D

@export var refill_time : float = 3.0
@export var animation_time : float = 0.3

var refill_timer : float = 0
var taken = 0

# Signal for body enterering this area
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not taken:
		$AnimatedSprite2D.animation = "idle"
	else:
		if taken and refill_timer == 0:
			$Music.play()
		if refill_timer > refill_time and taken:
			taken = 0
			refill_timer = 0
			$AnimatedSprite2D.animation = "idle"
		elif refill_timer < animation_time and taken:
			$AnimatedSprite2D.animation = "flash"
			refill_timer += delta
		else:
			refill_timer += delta
			$AnimatedSprite2D.animation = "outline"
	$AnimatedSprite2D.play()
	


func _on_body_entered(body: Node2D) -> void:
	if body is Player and body.dash != 2 and not taken:
		body.dash = 2
		taken = 1
		
