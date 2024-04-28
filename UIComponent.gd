extends Node2D

@export var energy_component: EnergyComponent
func _ready():
	%EnergyBarUI.max_value = energy_component.MAX_ENERGY;
	%EnergyBarUI.value = %EnergyBarUI.max_value

func _process(delta):
	%EnergyBarUI.value = energy_component.energy
