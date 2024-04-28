extends Node2D

@export var base_cost: float
@export var energy_component: EnergyComponent
@export var ship_light_base_intensity: float
@export var ship_light_depleted_intensity: float
@export var flashlight_intensity = 0.5
@export var flashlight_cost: float
var is_flashlight_on = false

func _ready():
	energy_component.energy_depleted.connect(_on_energy_depleted)
	energy_component.energy_restored.connect(_on_energy_restored)
	
func _process(delta):
	energy_component.use(base_cost * delta)
	if is_flashlight_on:
		energy_component.use(flashlight_cost * delta)
	

func _on_energy_depleted():
	%ShipLight.energy = ship_light_depleted_intensity
	is_flashlight_on = false
	%Flashlight.energy = 0

func _on_energy_restored():
	%ShipLight.energy = ship_light_base_intensity

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.pressed:
			if energy_component.check(flashlight_cost * get_process_delta_time()):
				is_flashlight_on = !is_flashlight_on
				if is_flashlight_on:
					%Flashlight.energy = flashlight_intensity
				else:
					%Flashlight.energy = 0
