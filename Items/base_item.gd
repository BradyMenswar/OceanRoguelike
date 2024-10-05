extends Resource
class_name BaseItem

@export var texture: Texture2D
@export var name: String
@export var rarity: int
@export var heat_cost: float
@export var activate_every_stage: bool

func apply_effects():
	pass
