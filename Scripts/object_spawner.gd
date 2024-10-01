extends Node2D

var vent_scene = preload("res://vent.tscn")

var vent_nodes
func _ready() -> void:
	GlobalSignal.tilemap_generated.connect(_on_tilemap_generated)


func _on_tilemap_generated(map_manager_ref: MapManager):
	vent_nodes = PoissonDiscSampler.generate_poisson(map_manager_ref.tile_layer, 1000, 5)
	for node in vent_nodes:
		print(node)
		#var vent_instance = vent_scene.instantiate()
		#vent_instance.global_position = node
		#get_parent().add_child.call_deferred(vent_instance)
