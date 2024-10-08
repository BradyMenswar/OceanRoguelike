extends CharacterBody2D
class_name Player
 
@export var base_speed: float = 300
@export var depleted_multiplier: float
@export var acceleration: float = 50
@export var energy_component: EnergyComponent
@export var reactor_component: ReactorComponent

var current_depleted_multiplier: float = 1
var nearest_vent

func _ready() -> void:
	apply_stats()
	#energy_component.energy_depleted.connect(_on_energy_depleted)
	#energy_component.energy_restored.connect(_on_energy_restored)
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)
	GlobalSignal.stats_changed.connect(_on_stats_changed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_camera"):
		print("change Camera")
	elif event.is_action_pressed("interact") and nearest_vent:
		GlobalSignal.vent_event_started.emit(nearest_vent)
			

func _physics_process(_delta) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity.x = move_toward(velocity.x, base_speed * current_depleted_multiplier * input_direction.x, acceleration)
	velocity.y = move_toward(velocity.y, base_speed * current_depleted_multiplier * input_direction.y, acceleration)
	move_and_slide()
	
	
func apply_stats() -> void:
	base_speed = GameGlobals.current_stats[GameGlobals.Stats.MoveSpeed]
	
	
func _on_stats_changed() -> void:
	apply_stats()


#func _on_energy_depleted() -> void:
	#current_depleted_multiplier = depleted_multiplier
#
#
#func _on_energy_restored() -> void:
	#current_depleted_multiplier = 1


func _on_vent_event_completed(_essence_amount) -> void:
	pass
