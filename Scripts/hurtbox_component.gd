extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent

func damage(amount: float):
	if health_component:
		health_component.damage(amount)