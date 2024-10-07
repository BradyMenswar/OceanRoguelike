extends Node2D
class_name EnergyComponent

signal energy_depleted
signal energy_restored
signal energy_changed(energy: float, max_energy: float)

@export var max_energy: float = 10.0
var energy: float

func _ready() -> void:
	energy = max_energy
	

func use(amount: float) -> void:
	energy -= amount
	if energy <= 0:
		energy_depleted.emit()
	energy_changed.emit(energy, max_energy)


func check(amount: float) -> bool:
	if amount > energy:
		return false
	return true
	

func charge(amount: float):
	if energy <= 0:
		energy_restored.emit()
	energy += amount;
	if energy > max_energy:
		energy = max_energy
	energy_changed.emit(energy, max_energy)
