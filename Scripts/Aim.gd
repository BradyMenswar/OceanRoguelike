extends Node2D

func _process(_delta) -> void:
	look_at(get_global_mouse_position())
	rotate(PI / 2)
