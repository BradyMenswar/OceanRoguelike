extends Area2D

@export var charge_rate: float = 5.0

var is_charging: bool = false
var energy_component: EnergyComponent

func _process(delta) -> void:
	if is_charging:
		energy_component.charge(charge_rate * delta)

		
func _on_body_entered(body) -> void:
	if body.has_node("EnergyComponent"):
		energy_component = body.get_node("EnergyComponent")
		is_charging = true
		

func _on_body_exited(body) -> void:
	if body.has_node("EnergyComponent"):
		is_charging = false
