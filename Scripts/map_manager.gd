extends Node2D

const EMPTY = 0
const WALL = 1
const FLOOR = 2
const NEIGHBORS = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]

const WALL_BIT = "0"
const FLOOR_BIT = "1"

@export var map_size: int = 100
@export var tile_size: int = 128
@export var walker_count: int = 20
@export var walker_steps: int = 1750
@export var clean_iterations: int = 2

@export var floor_atlas = Vector2i(0, 3)
@export var wall_atlas = Vector2i(2, 1)
@onready var tile_layer = $BaseTiles
@onready var display_layer = $DisplayTiles

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
	"1111": Vector2i(0, 3)  # No corners
}
	


func _ready() -> void:
	tile_layer.position.x  = -tile_size * map_size / 2
	tile_layer.position.y  = -tile_size * map_size / 2
	display_layer.position.x  = (-tile_size * map_size / 2) - (tile_size / 2)
	display_layer.position.y  = (-tile_size * map_size / 2 ) - (tile_size / 2)
	seed(12345)
	generate_map()
	
	for coord in tile_layer.get_used_cells():
		set_display_tile(coord)
	


func initialize_map():
	for row in range(map_size):
		map.push_back([])
		for col in range(map_size):
			map[row].push_back({"state": EMPTY})


func generate_map():
	initialize_map()
	walk()
	clean_inside()
	calculate_walls()
	draw_map()
	

func walk():
	for iteration in range(walker_count):
		var current_location = Vector2(map_size / 2, map_size / 2)
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

func calculate_walls():
	for row in range(map.size()):
		for col in range (map[row].size()):
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


func clean_inside():
	for iteration in range(clean_iterations):
		for row in range(map.size()):
			for col in range (map[row].size()):
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
						

func draw_map():
	var floor_tiles = []
	for row in range(map.size()):
		for col in range (map[row].size()):
			floor_tiles.push_back(Vector2i(row,col))
			var current_tile = map[row][col]
			if current_tile.state == EMPTY:
				#tile_layer.set_cell(Vector2i(row, col), 0, Vector2i(2,5))
				pass
			elif current_tile.state == WALL:
				tile_layer.set_cell(Vector2i(row, col), 0, wall_atlas)
				pass
			elif current_tile.state == FLOOR:
				tile_layer.set_cell(Vector2i(row, col), 0, floor_atlas)
				pass

func set_display_tile(base_position):
	for index in range(NEIGHBORS.size()):
		var new_position = base_position + NEIGHBORS[index]
		display_layer.set_cell(new_position, 0, calculate_display_tile(new_position))
		

func calculate_display_tile(coords):
	var bottom_right = get_base_tile(coords - NEIGHBORS[0])
	var bottom_left = get_base_tile(coords - NEIGHBORS[1])
	var top_right = get_base_tile(coords - NEIGHBORS[2])
	var top_left = get_base_tile(coords - NEIGHBORS[3])
	
	return neighbors_to_atlas[top_left + top_right + bottom_left + bottom_right]
	
func get_base_tile(coords):
	var atlas = tile_layer.get_cell_atlas_coords(coords)
	if atlas == floor_atlas:
		return FLOOR_BIT;
	return WALL_BIT
