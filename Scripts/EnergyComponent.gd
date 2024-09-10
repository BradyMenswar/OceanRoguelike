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
		emit_signal("energy_depleted")
	GlobalSignal.emit_signal("energy_changed", energy, MAX_ENERGY)

func check(amount: float):
	if amount > energy:
		return false
	return true
	
func charge(amount: float):
	if energy <= 0:
		emit_signal("energy_restored")
	energy += amount;
	if energy > MAX_ENERGY:
		energy = MAX_ENERGY
	GlobalSignal.emit_signal("energy_changed", energy, MAX_ENERGY)
