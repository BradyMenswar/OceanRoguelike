extends VBoxContainer

@export var energy_component: EnergyComponent
@onready var label: Label = $EnergyLabel
@onready var energy_meter: ProgressBar = $EnergyMeter

func _ready() -> void:
	energy_component.energy_changed.connect(_on_energy_changed)
	energy_meter.max_value = energy_component.max_energy;
	energy_meter.value = energy_meter.max_value


func _on_energy_changed(current_amount: float, player_max_energy: float) -> void:
	energy_meter.value = current_amount
	if energy_meter.max_value != player_max_energy:
		energy_meter.max_value = player_max_energy
