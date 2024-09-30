extends Node2D
class_name Minimap

@onready var minimap_tiles = $MinimapTiles
@onready var fog_tiles = $FogTiles
@onready var camera = $Camera2D
@onready var player_marker = $PlayerMarker

@export var fog_radius: float = 40.5
@export var default_zoom: Vector2 = Vector2(0.095, 0.095)
@export var expanded_zoom: Vector2

var minimap_expanded: bool = false
var debug_map_revealed: bool = false
var player
var map_manager: MapManager

func _ready() -> void:
	camera.zoom = default_zoom
	initialize_fog()
	set_tile_map()
	GlobalSignal.player_spawned.connect(_on_player_spawned)
	var minimap_size = 256
	var tile_size = 256 * 0.5
	var tile_map_rect: Rect2i = map_manager.tile_layer.get_used_rect()
	var larger_scale = max(tile_map_rect.size.x, tile_map_rect.size.y)
	expanded_zoom = Vector2(minimap_size / (float(larger_scale) * tile_size), minimap_size / (float(larger_scale) * tile_size))
	camera.limit_left = tile_map_rect.position.x * tile_size
	camera.limit_right = (tile_map_rect.position.x + tile_map_rect.size.x) * tile_size - 256
	camera.limit_top = tile_map_rect.position.y * tile_size
	camera.limit_bottom = (tile_map_rect.position.y + tile_map_rect.size.y) * tile_size - 256

func _process(_delta: float) -> void:
	if player:
		camera.global_position = player.global_position
		player_marker.global_position = player.global_position
	update_fog()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("expand_minimap"):
		expand_minimap()
	if event.is_action_pressed("debug_show_map"):
		if debug_map_revealed:
			fog_tiles.show()
		else:
			fog_tiles.hide()
		debug_map_revealed = !debug_map_revealed


func update_fog() -> void:
	var marker_position = fog_tiles.local_to_map(fog_tiles.to_local(player_marker.global_position))
	
	var top = ceil(marker_position.y - fog_radius)
	var bottom = floor(marker_position.y + fog_radius)
	var left = ceil(marker_position.x - fog_radius)
	var right = floor(marker_position.x + fog_radius)

	for row in range(top, bottom + 1):
		for col in range(left, right + 1):
			if inside_circle(marker_position, Vector2i(col, row), fog_radius):
				fog_tiles.set_cell(Vector2i(col, row), 0, Vector2i(0, 1))


func inside_circle(center: Vector2i, tile_coords: Vector2i, radius: float) -> bool:
	var x_distance = center.x - tile_coords.x
	var y_distance = center.y - tile_coords.y

	var distance_squared = x_distance * x_distance + y_distance * y_distance;
	return distance_squared <= radius * radius;


func initialize_fog() -> void:
	# need to reorient the fog to fit the entire displayed map
	var tile_scale = map_manager.tile_scale
	var map_rect: Rect2i = map_manager.tile_layer.get_used_rect()
	var larger_scale = max(map_rect.size.x, map_rect.size.y)
	for row in range(map_rect.position.y, map_rect.position.y + larger_scale):
		for col in range(map_rect.position.x, map_rect.position.x + larger_scale):
			fog_tiles.set_cell(Vector2i(col, row), 0, Vector2i(0, 0))
			
	fog_tiles.scale.x = tile_scale
	fog_tiles.scale.y = tile_scale


func set_tile_map() -> void:
	var base_tiles = map_manager.display_layer
	for tile_coords in base_tiles.get_used_cells():
		var old_cell_atlas = map_manager.display_layer.get_cell_atlas_coords(tile_coords)
		minimap_tiles.set_cell(tile_coords, 2, old_cell_atlas)
	
	var tile_scale = map_manager.tile_scale
	var tile_size = map_manager.tile_size
	
	minimap_tiles.scale.x = tile_scale
	minimap_tiles.scale.y = tile_scale
	minimap_tiles.position.x =  -(tile_size * tile_scale / 2)
	minimap_tiles.position.y =  -(tile_size * tile_scale / 2)


func _on_player_spawned(player_ref) -> void:
	player = player_ref
	
	
func expand_minimap() -> void:
	minimap_expanded = !minimap_expanded
	if minimap_expanded:
		camera.zoom = expanded_zoom
	else:
		camera.zoom = default_zoom
	GlobalSignal.minimap_expand_toggled.emit(minimap_expanded)
