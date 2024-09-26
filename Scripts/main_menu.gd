extends Control

var pilot_select = "res://Levels/pilot_select.tscn"

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file(pilot_select)
