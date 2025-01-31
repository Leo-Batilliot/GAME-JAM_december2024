class_name LevelMenu
extends Control

func _ready() -> void:
	deactivate()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("echap"):
		get_node("../MainMenu").activate()
		deactivate()

func deactivate() -> void:
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)

func activate() -> void:
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)
