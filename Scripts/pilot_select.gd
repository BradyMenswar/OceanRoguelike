extends Control

var game_scene = "res://Levels/main_scene.tscn"
var pilots = ["res://Pilots/ar_pilot.tres", "res://Pilots/shotgun_pilot.tres", "res://Pilots/smg_pilot.tres"]

func _on_pilot_1_pressed() -> void:
	GameGlobals.current_pilot = load(pilots[0])
	get_tree().change_scene_to_file(game_scene)

func _on_pilot_2_pressed() -> void:
	GameGlobals.current_pilot = load(pilots[1])
	get_tree().change_scene_to_file(game_scene)


func _on_pilot_3_pressed() -> void:
	GameGlobals.current_pilot = load(pilots[2])
	get_tree().change_scene_to_file(game_scene)
