extends Node2D

@export var energy_component: EnergyComponent

func _ready() -> void:
	%EnergyBarUI.max_value = energy_component.MAX_ENERGY;
	%EnergyBarUI.value = %EnergyBarUI.max_value


func _process(_delta) -> void:
	%EnergyBarUI.value = energy_component.energy
