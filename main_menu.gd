extends Control

var game_scene = "res://main_scene.tscn"

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)
