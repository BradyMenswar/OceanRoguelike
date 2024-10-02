extends Control

var game_scene = "res://Levels/main_scene.tscn"
var pilots = ["res://Pilots/ar_pilot.tres", "res://Pilots/shotgun_pilot.tres", "res://Pilots/smg_pilot.tres"]

func _on_pilot_1_pressed() -> void:
	start_game(0)


func _on_pilot_2_pressed() -> void:
	start_game(1)


func _on_pilot_3_pressed() -> void:
	start_game(2)


func start_game(pilot_index: int):
	GameGlobals.current_pilot = load(pilots[pilot_index])
	GameGlobals.set_seed()
	get_tree().change_scene_to_file(game_scene)
