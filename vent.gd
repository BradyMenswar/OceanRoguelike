extends Node2D

@onready var key_prompt = $KeyPrompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key_prompt.hide()

func _on_activate_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		body.within_range_of_vent = true
		key_prompt.show()


func _on_activate_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		body.within_range_of_vent = false
		key_prompt.hide()
