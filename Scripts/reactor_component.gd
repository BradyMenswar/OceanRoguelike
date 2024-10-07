extends Node
class_name ReactorComponent

@onready var cooldown_timer = $CooldownTimer
@onready var decay_timer = $DecayTimer

@export var overheat_duration: float = 3.0

var heat: float = 0
var is_overheated: bool = false


func use(amount: float) -> void:
	heat += amount
	if heat >= 100.0:
		is_overheated = true
		cooldown_timer.start()
		GlobalSignal.reactor_overheated.emit()
	GlobalSignal.reactor_changed.emit(heat)
