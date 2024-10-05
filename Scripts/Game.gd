extends Node2D

@onready var player = preload("res://Player.tscn");
var shop_scene = "res://Levels/shop_scene.tscn"

func _ready() -> void:
	var player_instance: Node = player.instantiate()
	add_child(player_instance)
	GlobalSignal.player_spawned.emit(player_instance)
	GlobalSignal.stage_entered.emit(GameGlobals.current_stage)
	GlobalSignal.stage_completed.connect(_on_stage_completed)
	
func _on_stage_completed():
	GameGlobals.reset_stage_properties()
	get_tree().change_scene_to_file(shop_scene)
