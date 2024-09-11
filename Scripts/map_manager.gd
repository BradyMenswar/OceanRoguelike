extends Node2D

const EMPTY = 0
const WALL = 1
const FLOOR = 2

@export var map_size: int = 100
@export var tile_size: int = 32
@export var walker_count: int = 10
@export var walker_steps: int = 1000
@export var clean_iterations: int = 5
@onready var tile_layer = $BaseTiles
var map = []

func _ready() -> void:
	tile_layer.position.x  = -tile_size * 2 * map_size / 2
	tile_layer.position.y  = -tile_size * 2 * map_size / 2
	seed(12345)
	generate_map()
	


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
	for row in range(map.size()):
			for col in range (map[row].size()):
				var current_tile = map[row][col]
				if current_tile.state == EMPTY:
					#tile_layer.set_cell(Vector2i(row, col), 0, Vector2i(4,6))
					pass
				elif current_tile.state == WALL:
					tile_layer.set_cell(Vector2i(row, col), 0, Vector2i(4,6))
				elif current_tile.state == FLOOR:
					tile_layer.set_cell(Vector2i(row, col), 0, Vector2i(1,1))
