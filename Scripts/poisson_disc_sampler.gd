extends Node
class_name PoissonDiscSampler

static func generate_poisson(tile_map: TileMapLayer, min_distance: float, resampling_count: int):
	var rect_bounds = tile_map.get_used_rect()
	var cell_size = min_distance / sqrt(2)
	var grid2D = Grid2D.new(ceil(rect_bounds.size.x * 128 / cell_size), ceil(rect_bounds.size.y * 128 / cell_size))
	print(grid2D.get_grid_count())
	var process_list: Array[Vector2]
	var sample_list: Array[Vector2]
	
	var initial_cell = tile_map.get_used_cells().pick_random()
	var initial_point = Vector2(initial_cell.x * 128, initial_cell.y * 128)
	
	process_list.push_back(initial_point)
	sample_list.push_back(initial_point)
	grid2D.set_point(image_to_grid(initial_point, cell_size), initial_point)
	
	while !process_list.is_empty():
		if sample_list.size() > 150: break;
		var random_index = randi_range(0, process_list.size() - 1)
		var process_point = process_list.pop_at(random_index)
		for _index in range(0, resampling_count):
			var new_point = generate_random_point_around(process_point, min_distance)
			if is_point_in_tilemap(tile_map, new_point) and not is_in_neighborhood(grid2D.grid, new_point, min_distance, cell_size):
				process_list.push_back(new_point)
				sample_list.push_back(new_point)
				grid2D.set_point(image_to_grid(new_point, cell_size), new_point)
	print(sample_list.size())
	return sample_list


static func image_to_grid(point: Vector2, cell_size: float) -> Vector2i:
	var grid_x = int(point.x / cell_size)
	var grid_y = int(point.y / cell_size)
	return Vector2i(grid_x, grid_y);


static func generate_random_point_around(point: Vector2, min_distance: float) -> Vector2:
	var radius_modifier = randf()
	var angle_modifier = randf()
	
	var radius = min_distance * (radius_modifier + 1)
	var angle = 2 * PI * angle_modifier
	
	return Vector2(point.x + radius * cos(angle), point.y + radius * sin(angle))


static func is_point_in_tilemap(tile_map: TileMapLayer, point: Vector2) -> bool:
	var floored_point = Vector2i(point)
	var map_coord = tile_map.local_to_map(tile_map.to_local(floored_point))
	#var cell_atlas = tile_map.get_cell_source_id(map_coord)
	
	return tile_map.get_used_cells().has(map_coord)
	
	#return tile_map.get_used_rect().has_point(Vector2i(point))
	
	
static func is_in_neighborhood(grid, point: Vector2, min_distance: float, cell_size: float) -> bool:
	var grid_translation = image_to_grid(point, cell_size)
	var cells_around_point = get_surrounding_cells(grid, grid_translation)
	print(cells_around_point.size())
	for cell in cells_around_point:
		if cell != null:
			if cell.distance_to(point) < min_distance:
				return true
	return false
	
	
static func get_surrounding_cells(grid, center: Vector2i):
	var surrounding_cells = []
	print("center: " + str(center))
	for i in range(-2, 3):
		for j in range(-2, 3):
			if i == 0 and j == 0: continue
			var x = center.x + i
			var y = center.y + j
			
			if x >= 0 and x < grid.size() and y >= 0 and y < grid[0].size():
				surrounding_cells.append(grid[x][y])
	return surrounding_cells