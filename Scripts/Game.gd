extends Node2D

@onready var player = preload("res://Player.tscn");

func _ready():
	var player_instance = player.instantiate()
	add_child(player_instance)
	GlobalSignal.player_spawned.emit(player_instance)
