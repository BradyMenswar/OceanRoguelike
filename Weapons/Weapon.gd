extends Resource

class_name Weapon

enum FiringMode {
	Semi,
	Auto
}

@export var fire_rate: float
@export var spread_angle: float
@export var bullet_count: int
@export var firing_mode: FiringMode
@export var max_range: float
@export var shot_speed: float
@export var heat_cost: float
@export var damage: float
