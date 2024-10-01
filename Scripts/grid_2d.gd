extends Node
class_name Grid2D

var grid = []

func _init(width, height) -> void:
	for i in range(width):
		grid.push_back([])
		for j in range(height):
			grid[i].push_back(null)

func set_point(point: Vector2i, value: Vector2):
	if grid[point.x][point.y] != null:
		print("OVERWRITING POINT: "+  str(point))
	grid[point.x][point.y] = value

func get_grid_count():
	var count = 0
	for i in range(grid.size()):
		for j in range(grid[i].size()):
			count += 1
	return count
