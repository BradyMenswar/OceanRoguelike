extends BaseItem
class_name MinimapRevealItem

@export var reveal_objects: Array[GameGlobals.Objects]

func apply_effects():
	GlobalSignal.minimap_objects_reveal.emit(reveal_objects)
