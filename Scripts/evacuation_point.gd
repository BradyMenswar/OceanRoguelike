extends Area2D

var player_in_radius = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_radius:
		if(GameGlobals.current_essence >= GameGlobals.essence_requirements[GameGlobals.current_stage]):
			GlobalSignal.stage_completed.emit()
		else:
			print("Not enough essence")


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_in_radius = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_in_radius = false
