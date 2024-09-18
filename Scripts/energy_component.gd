extends Node2D
class_name EnergyComponent

signal energy_depleted
signal energy_restored

@export var MAX_ENERGY := 10.0
var energy: float

func _ready():
	energy = MAX_ENERGY
	
func use(amount: float):
	energy -= amount
	if energy <= 0:
		energy_depleted.emit()
	GlobalSignal.energy_changed.emit(energy, MAX_ENERGY)

func check(amount: float):
	if amount > energy:
		return false
	return true
	
func charge(amount: float):
	if energy <= 0:
		energy_restored.emit()
	energy += amount;
	if energy > MAX_ENERGY:
		energy = MAX_ENERGY
	GlobalSignal.energy_changed.emit(energy, MAX_ENERGY)
