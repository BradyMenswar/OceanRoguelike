extends Area2D

@onready var destroy_timer = $DestroyTimer
var max_range: float
var speed: float

var travelled_distance := 0.0
	
func _physics_process(delta: float) -> void:
	var distance := speed * delta
	var motion := transform.x * speed * delta
	position += motion
	
	travelled_distance += distance
	if travelled_distance > max_range:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
