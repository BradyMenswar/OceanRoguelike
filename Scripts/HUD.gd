extends CanvasLayer

@onready var essence_ui = $EssenceTotal
@onready var seed_text = $Seed
@onready var minimap_viewport = $SubViewportContainer/MinimapViewport
var minimap_scene := preload("res://minimap.tscn")

var default_minimap_size = Vector2(256, 256)
var expanded_minimap_size = Vector2(512, 512)

var max_energy: float
var essence_total: float = 0.0

func _ready() -> void:
	GlobalSignal.energy_changed.connect(_on_energy_changed)
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)
	GlobalSignal.tilemap_generated.connect(_on_tilemap_generated)
	GlobalSignal.minimap_expand_toggled.connect(_on_minimap_expand_toggled)
	update_essence_ui()
	%EnergyBarUI.max_value = max_energy
	%EnergyBarUI.value = %EnergyBarUI.max_value
	seed_text.text = "Seed: " + str(GameGlobals.run_seed)


func _on_energy_changed(current_amount: float, player_max_energy: float) -> void:
	%EnergyBarUI.value = current_amount
	if max_energy != player_max_energy:
		max_energy = player_max_energy
		%EnergyBarUI.max_value = max_energy


func _on_vent_event_completed(essence_amount) -> void:
	essence_total += essence_amount
	update_essence_ui()
	

func _on_tilemap_generated(map_manager):
	var minimap_instance = minimap_scene.instantiate()
	minimap_instance.map_manager = map_manager
	minimap_viewport.add_child(minimap_instance)
	
	
func _on_minimap_expand_toggled(minimap_expanded: bool) -> void:
	if minimap_expanded:
		minimap_viewport.size = expanded_minimap_size 
	else:
		minimap_viewport.size = default_minimap_size


func update_essence_ui() -> void:
	essence_ui.text = "Total Essence: " + str(essence_total) + "/" + str(GameGlobals.STAGE_ONE_ESSENCE_REQUIREMENT)
