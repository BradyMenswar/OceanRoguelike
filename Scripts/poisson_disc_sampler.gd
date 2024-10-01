extends Node


func generate_poisson(rect_bounds: Rect2i, min_distance: float, resampling_count: int):
	var cell_size = min_distance / sqrt(2)
	var grid: Array[Vector2] = []
	
	var process_list: Array[Vector2]
	var sample_list: Array[Vector2]
	
	var initial_point = Vector2(randf_range(0, rect_bounds.size.x), randf_range(0, rect_bounds.size.y))
	
	process_list.push_back(initial_point)
	sample_list.push_back(initial_point)
	grid[image_to_grid(initial_point, cell_size)] = initial_point
#generate_poisson(width, height, min_dist, new_points_count)
#{
  #//Create the grid
  #cellSize = min_dist/sqrt(2);
#
  #grid = Grid2D(Point(
	#(ceil(width/cell_size),         //grid width
	#ceil(height/cell_size))));      //grid height
#
  #//RandomQueue works like a queue, except that it
  #//pops a random element from the queue instead of
  #//the element at the head of the queue
  #processList = RandomQueue();
  #samplePoints = List();
#
  #//generate the first point randomly
  #//and updates 
#
  #firstPoint = Point(rand(width), rand(height));
#
  #//update containers
  #processList.push(firstPoint);
  #samplePoints.push(firstPoint);
  #grid[imageToGrid(firstPoint, cellSize)] = firstPoint;
#
  #//generate other points from points in queue.
  #while (not processList.empty())
  #{
	#point = processList.pop();
	#for (i = 0; i < new_points_count; i++)
	#{
	  #newPoint = generateRandomPointAround(point, min_dist);
	  #//check that the point is in the image region
	  #//and no points exists in the point's neighbourhood
	  #if (inRectangle(newPoint) and
		#not inNeighbourhood(grid, newPoint, min_dist,
		  #cellSize))
	  #{
		#//update containers
		#processList.push(newPoint);
		#samplePoints.push(newPoint);
		#grid[imageToGrid(newPoint, cellSize)] =  newPoint;
	  #}
	#}
  #}
  #return samplePoints;
#}

func image_to_grid(point: Vector2, cell_size: float) -> Vector2i:
	var grid_x = (int)(point.x / cell_size)
	var grid_y = (int)(point.y / cell_size)
	return Vector2i(grid_x, grid_y);
