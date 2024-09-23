extends Node2D

@onready var player = preload("res://Player.tscn");

var total_essence := 0.0

func _ready() -> void:
	var player_instance: Node = player.instantiate()
	add_child(player_instance)
	GlobalSignal.player_spawned.emit(player_instance)
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)
	
	
func _on_vent_event_completed(essence_amount):
	total_essence += essence_amount
