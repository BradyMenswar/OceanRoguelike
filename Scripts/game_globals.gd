extends Node

enum Stats {MoveSpeed, FireRate}
enum Objects {Vent, Pylon}

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

var player_instance

var current_items: Array[BaseItem] = []
var current_stats: Array[float] = []
var current_on_hits: Array[BaseItem] = []

func _ready() -> void:
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)
	GlobalSignal.stage_entered.connect(_on_stage_entered)

func _on_vent_event_completed(essence_amount) -> void:
	current_essence += essence_amount
	

func reset_stage_properties():
	current_essence = 0.0
	

func _on_stage_entered(_stage_index):
	for item in current_items:
		if item.activate_every_stage:
			item.apply_effects()
	

func set_seed(chosen_seed = null):
	if chosen_seed == null:
		run_seed = 1000 + (1000 * (randi() % 10000))
	else:
		run_seed = chosen_seed
	seed(run_seed)
	
	
func equip_item(item_resource: BaseItem):
	current_items.append(item_resource)
	item_resource.apply_effects()
	
	
func set_current_stats(set_stats):
	for stat in range(Stats.keys().size()):
		current_stats.append(0)
		current_stats[stat] = set_stats[stat]
