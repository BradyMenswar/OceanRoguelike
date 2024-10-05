extends Area2D

@onready var sprite = $Sprite2D

@export var item_resource: BaseItem
var player_in_radius = false

func _ready() -> void:
	sprite.texture = item_resource.texture


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_radius:
		GameGlobals.equip_item(item_resource)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_radius = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_radius = false
