extends Node

const STAGE_ONE_ESSENCE_REQUIREMENT: float = 300.0
const STAGE_TWO_ESSENCE_REQUIREMENT: float = 400.0

var essence_requirements = [STAGE_ONE_ESSENCE_REQUIREMENT, STAGE_TWO_ESSENCE_REQUIREMENT]

var current_stage = 0
var current_pilot: Pilot = load("res://Pilots/ar_pilot.tres")
var run_seed = 12345

var tile_size = 256
var tile_scale = 0.5

var minimap_expanded: bool = false
var current_essence := 0.0


func _ready() -> void:
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)


func _on_vent_event_completed(essence_amount) -> void:
	current_essence += essence_amount
	

func reset_stage_properties():
	current_essence = 0.0


func set_seed(chosen_seed = null):
	if chosen_seed == null:
		run_seed = 1000 + (1000 * (randi() % 10000))
	else:
		run_seed = chosen_seed
	seed(run_seed)
