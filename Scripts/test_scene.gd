extends Node2D

@export var seed: int = 12345

func _init() -> void:
	GameGlobals.set_seed(seed)
