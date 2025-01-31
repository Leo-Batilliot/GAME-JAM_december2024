class_name MainMenu
extends Control

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	get_node("../LevelMenu").activate()
	$Click_sound.play()
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
