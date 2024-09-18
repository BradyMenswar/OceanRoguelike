extends CharacterBody2D
class_name Player
 
@export var base_speed = 300
@export var depleted_multiplier: float
@export var acceleration = 50
@export_range(0, 1) var turn_speed: float
@export var energy_component: EnergyComponent
var current_depleted_multiplier = 1

var nearest_vent

func _ready():
	energy_component.energy_depleted.connect(_on_energy_depleted)
	energy_component.energy_restored.connect(_on_energy_restored)
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_camera"):
		print("change Camera")
	elif event.is_action_pressed("interact") and nearest_vent:
		GlobalSignal.vent_event_started.emit(nearest_vent)
			

func _physics_process(_delta):
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity.x = move_toward(velocity.x, base_speed * current_depleted_multiplier * input_direction.x, acceleration)
	velocity.y = move_toward(velocity.y, base_speed * current_depleted_multiplier * input_direction.y, acceleration)
	#rotation = lerp_angle(rotation, rotation + get_angle_to(transform.origin + velocity), turn_speed)
	move_and_slide()
	
func _on_energy_depleted():
	current_depleted_multiplier = depleted_multiplier

func _on_energy_restored():
	current_depleted_multiplier = 1

func _on_vent_event_completed():
	pass
