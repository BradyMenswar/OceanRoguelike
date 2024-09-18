extends Node

@onready var player_camera: PhantomCamera2D = %PlayerCamera
@onready var vent_camera: PhantomCamera2D = %VentCamera


func _ready() -> void:
	GlobalSignal.player_spawned.connect(_on_player_spawned)
	GlobalSignal.vent_event_started.connect(_on_vent_event_started)
	GlobalSignal.vent_event_completed.connect(_on_vent_event_ended)


func _on_player_spawned(player_ref):
	player_camera.set_follow_target(player_ref)


func _on_vent_event_started(vent_ref):
	reset_camera_priorities()
	vent_camera.set_follow_target(vent_ref)
	vent_camera.set_priority(1)


func _on_vent_event_ended():
	reset_camera_priorities()
	player_camera.set_priority(1)


func reset_camera_priorities():
	for camera in get_tree().get_nodes_in_group("Camera"):
		if camera is PhantomCamera2D:
			camera.set_priority(0)
