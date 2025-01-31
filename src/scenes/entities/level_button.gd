extends Button

@export var level_id : int = 0

var level_data : LevelData

func _process(delta: float) -> void:
	level_data = LevelManager.get_level_data_by_id(level_id)
	text = level_data.level_name
	if not level_data.level_unlocked:
		icon = preload("res://sprites/lock.png")
	elif level_data.level_completed:
		icon = preload("res://sprites/check_mark.png")
	else:
		icon = preload("res://sprites/circle.png")

func _on_pressed() -> void:
	if level_data.level_unlocked:
		LevelManager.load_level(level_id)
		$Click_sound.play()
		get_node("../../../../../MainMenu/Music").stop()
		get_node("../../../../.").deactivate()
