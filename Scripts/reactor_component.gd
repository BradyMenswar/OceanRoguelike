extends Node
class_name ReactorComponent

signal reactor_changed(current_amount: float)
signal reactor_overheated()
signal reactor_cooled()

@onready var cooldown_timer = $CooldownTimer
@onready var decay_timer = $DecayTimer

@export var overheat_duration: float = 10.0
@export var decay_lockout_duration: float = 1
@export var decay_rate: float = 10

var heat: float = 0
var is_overheated: bool = false
var is_decay_lockout: bool = false


func _process(delta: float) -> void:
	if(!is_decay_lockout and heat != 0):
		heat = max(0, heat - decay_rate * delta)
		reactor_changed.emit(heat)
	

func use(amount: float) -> void:
	heat += amount
	if heat >= 100.0:
		is_overheated = true
		cooldown_timer.start(overheat_duration)
		reactor_overheated.emit()
	is_decay_lockout = true
	decay_timer.start(decay_lockout_duration)
	reactor_changed.emit(heat)


func _on_cooldown_timer_timeout() -> void:
	is_overheated = false
	reactor_cooled.emit()


func _on_decay_timer_timeout() -> void:
	is_decay_lockout = false
