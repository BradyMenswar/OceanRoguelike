extends Node2D

func _ready():
	var player = preload("res://Player.tscn");
	var playerInstance = player.instantiate()
	add_child(playerInstance)
