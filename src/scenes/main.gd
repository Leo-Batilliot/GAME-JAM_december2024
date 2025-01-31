extends Node

@export var available_levels : Array[LevelData]

@onready var _2d_scene = $"2DScene"

var save_path = "user://data.save"

func _ready() -> void:
	load_data()
	LevelManager.main_scene = _2d_scene
	LevelManager.levels = available_levels

func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	for level in available_levels:
		file.store_var(level.level_completed)
		file.store_var(level.level_unlocked)
	
func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		for level in available_levels:
			level.level_completed = file.get_var()
			level.level_unlocked = file.get_var()
			
