extends Node2D
class_name MapManager

const EMPTY = 0
const WALL = 1
const FLOOR = 2
const NEIGHBORS = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]

const WALL_BIT = "0"
const FLOOR_BIT = "1"

@onready var tile_layer = $BaseTiles
@onready var display_layer = $DisplayTiles

@export var tile_scale: float = 0.5
@export var map_size: int = 100
@export var tile_size: int = 128
@export var walker_count: int = 20
@export var walker_steps: int = 1750
@export var clean_iterations: int = 2

@export var floor_atlas = Vector2i(0, 3)
@export var wall_atlas = Vector2i(2, 1)

@export var starting_area_radius: float = 4.5

var map = []
var neighbors_to_atlas = {
	"0000": Vector2i(2, 1), # All corners
	"0001": Vector2i(3, 1), # Inner top-left corner
	"0010": Vector2i(2, 2), # Inner top-right corner
	"0011": Vector2i(1, 2), # Top edge
	"0100": Vector2i(2, 0), # Inner bottom-left corner
	"0101": Vector2i(3, 2), # Left edge
	"0110": Vector2i(0, 1), # Top-left bottom-right corners
	"0111": Vector2i(3, 3), # Outer top-left corner
	"1000": Vector2i(1, 1), # Inner bottom-right corner
	"1001": Vector2i(2, 3), # Bottom-left top-right corners
	"1010": Vector2i(1, 0), # Right edge
	"1011": Vector2i(0, 2), # Outer top-right corner
	"1100": Vector2i(3, 0), # Bottom edge
	"1101": Vector2i(0, 0), # Outer bottom-left corner
	"1110": Vector2i(1, 3), # Outer bottom-right corner
	"1111": Vector2i(0, 3) # No corners
}
	

func _ready() -> void:
	tile_layer.scale.x = tile_scale
	tile_layer.scale.y = tile_scale
	display_layer.scale.x = tile_scale
	display_layer.scale.y = tile_scale
	tile_layer.position.x = -tile_size * tile_scale * (floor(map_size) / 2)
	tile_layer.position.y = -tile_size * tile_scale * (floor(map_size) / 2)
	display_layer.position.x = (-tile_size * tile_scale * map_size / 2) - (tile_size * tile_scale / 2)
	display_layer.position.y = (-tile_size * tile_scale * map_size / 2) - (tile_size * tile_scale / 2)
	seed(GameGlobals.run_seed)
	generate_map()
	
	for coord in tile_layer.get_used_cells():
		set_display_tile(coord)
	
	GlobalSignal.tilemap_generated.emit(self)

func initialize_map() -> void:
	for row in range(map_size):
		map.push_back([])
		for col in range(map_size):
			map[row].push_back({"state": EMPTY})


func generate_map() -> void:
	initialize_map()
	walk()
	clear_radius(Vector2i(floor(map_size / 2), floor(map_size / 2)), starting_area_radius)
	clean_inside()
	calculate_walls()
	draw_map()
	

func walk() -> void:
	for iteration in range(walker_count):
		var current_location: Vector2i = Vector2i(floor(map_size) / 2, floor(map_size) / 2)
		var direction
		for step in range(walker_steps):
			direction = randi() % 4
			if direction == 0:
				if current_location.x < map_size - 1: current_location.x += 1
			elif direction == 1:
				if current_location.y < map_size - 1: current_location.y += 1
			elif direction == 2:
				if current_location.x > 0: current_location.x -= 1
			elif direction == 3:
				if current_location.y > 0: current_location.y -= 1
			map[current_location.x][current_location.y].state = FLOOR


func calculate_walls() -> void:
	for row in range(map.size()):
		for col in range(map[row].size()):
			if map[row][col].state == FLOOR:
				var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
				for direction in directions:
					var new_row = row + direction.x
					var new_col = col + direction.y
					var is_inbounds = new_row >= 0 and new_row < map.size() and new_col >= 0 and new_col < map.size()
					if is_inbounds and map[new_row][new_col].state == EMPTY:
						map[new_row][new_col].state = WALL
				if row == map.size() - 1 or col == map.size() - 1 or row == 0 or col == 0:
					map[row][col].state = WALL


func clean_inside() -> void:
	for iteration in range(clean_iterations):
		for row in range(map.size()):
			for col in range(map[row].size()):
				var surrounded_by_floor = true
				if map[row][col].state == EMPTY:
					var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
					for direction in directions:
						var new_row = row + direction.x
						var new_col = col + direction.y
						var is_outbounds = new_row < 0 or new_row >= map.size() or new_col < 0 or new_col >= map.size()
						if is_outbounds or map[new_row][new_col].state != FLOOR:
							surrounded_by_floor = false
					if surrounded_by_floor:
						map[row][col].state = FLOOR


func draw_map() -> void:
	var floor_tiles = []
	for row in range(map.size()):
		for col in range(map[row].size()):
			floor_tiles.push_back(Vector2i(row, col))
			var current_tile = map[row][col]
			if current_tile.state == EMPTY:
				pass
			elif current_tile.state == WALL:
				tile_layer.set_cell(Vector2i(row, col), 1, wall_atlas)
			elif current_tile.state == FLOOR:
				tile_layer.set_cell(Vector2i(row, col), 1, floor_atlas)


func clear_radius(center: Vector2i, radius: float):
	var top = ceil(center.y - radius)
	var bottom = floor(center.y + radius)
	var left = ceil(center.x - radius)
	var right = floor(center.x + radius)
	print("Center:" + str(center))
	print("Top:" + str(top))
	print("Bottom:" + str(bottom))
	print("Left:" + str(left))
	print("Right:" + str(right))
	for row in range(top, bottom + 1):
		for col in range(left, right + 1):
			print(str(row) + ',' + str(col))
			if inside_circle(center, Vector2i(col, row), radius):
				map[row][col].state = FLOOR


func inside_circle(center: Vector2i, tile_coords: Vector2i, radius: float) -> bool:
	var x_distance = center.x - tile_coords.x
	var y_distance = center.y - tile_coords.y

	var distance_squared = x_distance * x_distance + y_distance * y_distance;
	return distance_squared <= radius * radius;
	
	
func set_tile(coords: Vector2i, atlas_coords: Vector2i) -> void:
	tile_layer.set_cell(coords, 1, atlas_coords)
	set_display_tile(coords)


func set_display_tile(base_position) -> void:
	for index in range(NEIGHBORS.size()):
		var new_position = base_position + NEIGHBORS[index]
		display_layer.set_cell(new_position, 1, calculate_display_tile(new_position))
		

func calculate_display_tile(coords) -> Vector2i:
	var bottom_right = get_base_tile(coords - NEIGHBORS[0])
	var bottom_left = get_base_tile(coords - NEIGHBORS[1])
	var top_right = get_base_tile(coords - NEIGHBORS[2])
	var top_left = get_base_tile(coords - NEIGHBORS[3])
	
	return neighbors_to_atlas[top_left + top_right + bottom_left + bottom_right]


func get_base_tile(coords) -> String:
	var atlas = tile_layer.get_cell_atlas_coords(coords)
	if atlas == floor_atlas:
		return FLOOR_BIT;
	return WALL_BIT
