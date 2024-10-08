extends Control

@export var reactor_component: ReactorComponent
@onready var reactor_meter: ProgressBar = $ReactorMeter

func _ready() -> void:
	reactor_component.reactor_changed.connect(_on_reactor_changed)
	reactor_meter.max_value = 100.0
	reactor_meter.value = 0



func _on_reactor_changed(current_amount: float) -> void:
	reactor_meter.value = current_amount
