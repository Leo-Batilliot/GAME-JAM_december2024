class_name Level
extends Node

@export var level_id : int
@export var level_start_pos : Node2D

var level_data : LevelData

func _ready() -> void:
	level_data = LevelManager.get_level_data_by_id(level_id)

func _process(delta: float) -> void:
	if $Player.level_finished:
		level_data.level_completed = 1
		$Player.level_finished = 0
		if level_data.level_to_unlock_id != -1:
			print(LevelManager.get_level_data_by_id(level_data.level_to_unlock_id).level_name)
			LevelManager.get_level_data_by_id(level_data.level_to_unlock_id).level_unlocked = 1
		get_node("../../.").save()
		$Music.stop()
		get_node("../../UIMain/LevelMenu").activate()
		get_node("../../UIMain/MainMenu/Music").play()
		LevelManager.unload_level()
	if Input.is_action_just_pressed("echap"):
		$Music.stop()
		get_node("../../UIMain/LevelMenu").activate()
		get_node("../../UIMain/MainMenu/Music").play()
		LevelManager.unload_level()
		
