extends Node2D


func _ready() -> void:
	GlobalSignal.tilemap_generated.connect(_on_tilemap_generated)


func _on_tilemap_generated(map_manager_ref: MapManager):
	print(map_manager_ref.walker_count)
	pass
