extends BaseItem
class_name FogRadiusItem

@export var fog_radius: float


func apply_effects():
	GlobalSignal.minimap_fog_radius_changed.emit(fog_radius)
