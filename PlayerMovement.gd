extends CharacterBody2D

@export var base_speed = 300
@export var depleted_multiplier: float
@export var acceleration = 20
@export_range(0, 1) var turn_speed: float
@export var energy_component: EnergyComponent

var current_depleted_multiplier = 1

func _ready():
	energy_component.energy_depleted.connect(_on_energy_depleted)
	energy_component.energy_restored.connect(_on_energy_restored)

func _physics_process(_delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity.x = move_toward(velocity.x, base_speed * current_depleted_multiplier * input_direction.x, acceleration)
	velocity.y = move_toward(velocity.y, base_speed * current_depleted_multiplier * input_direction.y, acceleration)
	rotation = lerp_angle(rotation, rotation + get_angle_to(transform.origin + velocity), turn_speed)
	move_and_slide()
	
func _on_energy_depleted():
	current_depleted_multiplier = depleted_multiplier

func _on_energy_restored():
	current_depleted_multiplier = 1
