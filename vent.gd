extends Node2D

@onready var key_prompt = $KeyPrompt
@onready var vent_timer = $VentTimer
@onready var vent_boundary = $EventBoundary
@onready var tether = $Tether
@onready var harvester_light = $HarvesterLight
@onready var vent_light = $VentLight

var tether_body
@export var vent_depleted_light_energy = 0.25

var vent_duration: float = 10

var is_started = false
var is_completed = false

func _ready() -> void:
	handle_boundary(true)
	harvester_light.energy = 0
	key_prompt.hide()
	GlobalSignal.vent_event_started.connect(_on_vent_event_started)


func _process(_delta: float) -> void:
	if is_started and tether_body and !is_completed:
		tether.points[1].x = to_local(tether_body.global_position).x
		tether.points[1].y = to_local(tether_body.global_position).y


func _on_activate_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		tether_body = body
		if !is_started and !is_completed:
			body.nearest_vent = self
			key_prompt.show()


func _on_activate_zone_body_exited(body: Node2D) -> void:
	if body is Player:
		body.nearest_vent = null
		key_prompt.hide()
		if !is_started and !is_completed:
			tether_body = null


func _on_vent_event_started(vent_ref) -> void:
	is_started = true
	harvester_light.energy = 1
	vent_timer.start(vent_duration)
	handle_boundary(false)


func _on_vent_timer_timeout() -> void:
	GlobalSignal.vent_event_completed.emit()
	is_completed = true
	harvester_light.energy = 0
	vent_light.energy = vent_depleted_light_energy
	tether_body = null
	tether.points[1].x = 0
	tether.points[1].y = 0
	handle_boundary(true)

func handle_boundary(disabled_state: bool):
	for boundary in vent_boundary.get_children():
		if boundary is CollisionPolygon2D:
			boundary.disabled = disabled_state
