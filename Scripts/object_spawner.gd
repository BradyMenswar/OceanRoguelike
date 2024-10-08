extends Node2D

var vent_scene = preload("res://vent.tscn")
var pylon_scene = preload("res://pylon.tscn")

var vent_nodes
var pylon_nodes

func _ready() -> void:
	GlobalSignal.tilemap_generated.connect(_on_tilemap_generated)


func _on_tilemap_generated(map_manager_ref: MapManager):
	vent_nodes = PoissonDiscSampler.generate_poisson(map_manager_ref.tile_layer, 1500, 30)
	for node in vent_nodes:
		clear_radius_for_object(map_manager_ref, node, 2.5)
		var vent_instance = vent_scene.instantiate()
		vent_instance.global_position = node
		get_parent().add_child.call_deferred(vent_instance)
	GlobalSignal.object_positions_generated.emit(vent_nodes, GameGlobals.Objects.Vent)
	
	#pylon_nodes = PoissonDiscSampler.generate_poisson(map_manager_ref.tile_layer, 2200, 30)
	#for node in pylon_nodes:
		#clear_radius_for_object(map_manager_ref, node, 1.5)
		#var pylon_instance = pylon_scene.instantiate()
		#pylon_instance.global_position = node
		#get_parent().add_child.call_deferred(pylon_instance)
	#GlobalSignal.object_positions_generated.emit(pylon_nodes, GameGlobals.Objects.Pylon)
	
	map_manager_ref.draw_display_map()
	GlobalSignal.tilemap_changed.emit(map_manager_ref)


func clear_radius_for_object(map_manager_ref, center: Vector2, radius: float):
	var map_coord = map_manager_ref.tile_layer.local_to_map(map_manager_ref.tile_layer.to_local(Vector2i(center)))
	map_manager_ref.clear_radius(map_coord, radius)
