class_name Player
extends CharacterBody2D


@export var speed : float = 200.0
@export var jump_force : float = -175.0
@export var jump_time : float = 0.25
@export var coyote_time : float = 0.075
@export var gravity_multiplyer : float = 2.5
@export var dash_force : float = 800.0
@export var dash_time : float = 0.15
@export var momentum_keep_time : float = 0.10
@export var super_dash_scale : float = 0.6
@export var stamina_time : float = 4.0
@export var grab_force : float = 60.0
@export var wall_jump_force : float = 500.0
@export var wall_jump_time : float = 0.15
@export var dash : int = 1
@export var level_finished : bool = 0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping : bool = false
var jump_timer : float = 0
var coyote_timer : float = 0
var dash_timer : float = 0
var is_dashing : bool = false
var looking_direction = "right"
var looking_direction_at_dash = "right"
var dash_direction : Vector2 = Vector2(0, 0)
var momentum_keep_timer : float = 0
var super_dash : bool = false
var stamina_timer : float = 0
var can_control : bool = true
var wall_jump_timer : float = 0
var is_wall_jumping : bool = false
var sound_walk_count : int = 0
var sound_climb_count : int = 0

func _physics_process(delta: float) -> void:
	if not can_control: return

	# Add the gravity.
	if not is_on_floor() and not is_jumping and not is_dashing:
		velocity.y += gravity * gravity_multiplyer * delta
	
	# Coyote timer
	if not is_on_floor():
		coyote_timer += delta
	else:
		coyote_timer = 0

	# Reset super dash and stamina
	if is_on_floor():
		super_dash = 0
		stamina_timer = 0

	# Update momentum timer
	momentum_keep_timer += delta


	# Give back dash when on ground
	if is_on_floor() and not is_dashing:
		dash = 1 if not dash else dash
	
	
	
	# Manage wall climb
	if is_on_wall() and Input.is_action_pressed("grab") and not is_wall_jumping:
		velocity.x = 0
		if stamina_timer < stamina_time:
			velocity.y = 0
			if Input.is_action_pressed("up") and not Input.is_action_pressed("down"):
				velocity.y = -grab_force
				sound_climb_count += 1
				if sound_climb_count >= 20:
					$Walk_sound.play()
					sound_climb_count = 0
				stamina_timer += delta
			if Input.is_action_pressed("down") and not Input.is_action_pressed("up"):
				velocity.y = grab_force
				sound_climb_count += 1
				if sound_climb_count >= 20:
					$Walk_sound.play()
					sound_climb_count = 0
				stamina_timer += delta
		else:
			velocity.y = gravity * gravity_multiplyer * delta * 0.5
			sound_climb_count += 1
			if sound_climb_count >= 15:
				$Wall_slide_sound.play()
				sound_climb_count = 0 
	
	
	
	# Manage dash
	if Input.is_action_just_pressed("dash-key") and dash and not is_dashing:
		dash -= 1
		is_dashing = true
		$Dash_sound.play()
		looking_direction_at_dash = looking_direction
		dash_timer = 0
		dash_direction.x = int(Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"))
		dash_direction.y = int(Input.is_action_pressed("down") and not Input.is_action_pressed("up")) - int(Input.is_action_pressed("up") and not Input.is_action_pressed("down"))
		if dash_direction.x == 0 and dash_direction.y == 0:
			dash_direction.x = 1 if looking_direction_at_dash == "right" else -1
		dash_direction = dash_direction.normalized()
		
	if is_dashing and dash_timer < dash_time:
		velocity.x = dash_direction.x * dash_force
		velocity.y = dash_direction.y * dash_force * 0.6
		dash_timer += delta
		momentum_keep_timer = 0
	if is_dashing and dash_timer >= dash_time:
		dash_timer = 0
		is_dashing = false
		momentum_keep_timer = 0
		


	# Handle wall jump
	if Input.is_action_just_pressed("jump") and is_on_wall_only():
		velocity.y = -wall_jump_force
		velocity.x = wall_jump_force / 1.2 if looking_direction == "left" else -wall_jump_force / 1.2
		if momentum_keep_timer < momentum_keep_time:
			velocity.y *= 1.7
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
		is_wall_jumping = true
		$Wall_Jump_sound.play()
		is_dashing = false
	if is_wall_jumping and wall_jump_timer < wall_jump_time:
		wall_jump_timer += delta
	else:
		is_wall_jumping = false
		wall_jump_timer = 0


	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer < coyote_time):
		velocity.y = jump_force
		is_jumping = true
		$Jump_sound.play()
		is_dashing = false
	elif Input.is_action_pressed("jump") and is_jumping:
		velocity.y = jump_force
		
	if is_jumping and Input.is_action_pressed("jump") and jump_timer < jump_time:
		jump_timer += delta
#	elif coyote_time < coyote_timer:
	else:
		is_jumping = false
		jump_timer = 0
	
	if is_on_floor() and not is_dashing and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		sound_walk_count += 1
		if sound_walk_count >= 20:
			$Walk_sound.play()
			sound_walk_count = 0


	# Get the input direction and hawalk_soundndle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		$AnimatedSprite2D.flip_h = direction < 0
		if direction < 0:
			looking_direction = "left"
		else:
			looking_direction = "right"

	if not is_dashing and not is_wall_jumping:
		if direction:
			velocity.x = direction * speed
			
			
			if is_jumping and momentum_keep_timer < momentum_keep_time:
				super_dash = 1
			if super_dash:
				velocity.x = direction * super_dash_scale * dash_force
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	handle_animation()
	move_and_slide()


func handle_animation():
	if (is_jumping):
		$AnimatedSprite2D.animation = "jump"
	elif (is_on_wall() and Input.is_action_pressed("grab")):
		$AnimatedSprite2D.animation = "climb"
	elif Input.get_axis("move_left", "move_right"):
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	
func handle_danger() -> void:
	print("Player Died !")
	$Death_sound.play()
	visible = false
	can_control = false
	jump_timer = 0
	coyote_timer = 0
	dash_timer = 0
	is_jumping = 0
	momentum_keep_timer = 0
	is_dashing = 0
	
	await get_tree().create_timer(1).timeout
	reset_player()
	
func handle_win() -> void:
	print("LEVEL FINISHED !")
	can_control = false
	
	$Win_sound.play()
	await get_tree().create_timer(2).timeout
	level_finished = 1
	
func reset_player() -> void:
	global_position = LevelManager.loaded_level.level_start_pos.global_position
	visible = true
	can_control = true
	dash = 0
	$Revive_sound.play()
