extends CanvasLayer

@onready var essence_ui = $EssenceTotal
@onready var seed_text = $Seed
@onready var minimap_viewport = $SubViewportContainer/MinimapViewport
@onready var viewport_container = $SubViewportContainer

var minimap_scene := preload("res://minimap.tscn")
var default_minimap_size = Vector2(256, 256)
var expanded_minimap_size = Vector2(512, 512)

func _ready() -> void:
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)
	GlobalSignal.tilemap_generated.connect(_on_tilemap_generated)
	GlobalSignal.minimap_expand_toggled.connect(_on_minimap_expand_toggled)
	update_essence_ui()
	seed_text.text = "Seed: " + str(GameGlobals.run_seed)


func _on_vent_event_completed(_essence_amount) -> void:
	update_essence_ui()
	

func _on_tilemap_generated(map_manager):
	var minimap_instance = minimap_scene.instantiate()
	minimap_instance.map_manager = map_manager
	minimap_viewport.add_child(minimap_instance)
	
	
func _on_minimap_expand_toggled(minimap_expanded: bool) -> void:
	if minimap_expanded:
		#minimap_viewport.size = expanded_minimap_size 
		pass
	else:
		#minimap_viewport.size = default_minimap_size
		pass


func update_essence_ui() -> void:
	essence_ui.text = "Current Essence: " + str(GameGlobals.current_essence) + "/" + str(GameGlobals.essence_requirements[GameGlobals.current_stage])
