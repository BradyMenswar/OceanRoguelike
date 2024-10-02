extends Control

var game_scene = "res://Levels/main_scene.tscn"



func _on_next_level_pressed() -> void:
	GameGlobals.current_stage += 1
	get_tree().change_scene_to_file(game_scene)
