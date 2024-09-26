extends Node2D
class_name Minimap

@onready var minimap_tiles = $MinimapTiles
@onready var camera = $Camera2D
@onready var player_marker = $PlayerMarker

var player
var map_manager: MapManager

func _ready() -> void:
	set_tile_map()
	GlobalSignal.player_spawned.connect(_on_player_spawned)


func _process(delta: float) -> void:
	if player:
		camera.global_position = player.global_position
		player_marker.global_position = player.global_position


func set_tile_map() -> void:
	var base_tiles = map_manager.tile_layer
	for tile_coords in base_tiles.get_used_cells():
		var old_cell_atlas = base_tiles.get_cell_atlas_coords(tile_coords)
		minimap_tiles.set_cell(tile_coords, 1, old_cell_atlas)
	
	minimap_tiles.scale.x = map_manager.tile_scale
	minimap_tiles.scale.y = map_manager.tile_scale
	minimap_tiles.position.x = -map_manager.tile_size * map_manager.tile_scale * (floor(map_manager.map_size) / 2)
	minimap_tiles.position.y = -map_manager.tile_size * map_manager.tile_scale * (floor(map_manager.map_size) / 2)

func _on_player_spawned(player_ref) -> void:
	player = player_ref
