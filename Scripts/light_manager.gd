extends Node2D

@onready var ship_light = $"../ShipLight"
@export var flashlight: PointLight2D

@export var base_cost: float
#@export var energy_component: EnergyComponent
@export var reactor_component: ReactorComponent
@export var ship_light_base_intensity: float
@export var ship_light_depleted_intensity: float
@export var flashlight_intensity: float = 0.5
@export var flashlight_cost: float

var is_flashlight_on: bool = false

func _ready() -> void:
	#energy_component.energy_depleted.connect(_on_energy_depleted)
	#energy_component.energy_restored.connect(_on_energy_restored)
	
	reactor_component.reactor_overheated.connect(_on_reactor_overheated)
	reactor_component.reactor_cooled.connect(_on_reactor_cooled)
	pass

func _process(delta) -> void:
	#energy_component.use(base_cost * delta)
	if is_flashlight_on:
		reactor_component.use(flashlight_cost * delta)
		#energy_component.use(flashlight_cost * delta)
	

#func _on_energy_depleted() -> void:
	#ship_light.energy = ship_light_depleted_intensity
	#is_flashlight_on = false
	#%Flashlight.energy = 0
#
#
#func _on_energy_restored() -> void:
	#ship_light.energy = ship_light_base_intensity
	

func _on_reactor_overheated():
	is_flashlight_on = false
	ship_light.energy = ship_light_depleted_intensity
	flashlight.energy = 0
	pass
	

func _on_reactor_cooled():
	ship_light.energy = ship_light_base_intensity
	pass


func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 2 and event.pressed:
			if !reactor_component.is_overheated:
			#if energy_component.check(flashlight_cost * get_process_delta_time()):
				is_flashlight_on = !is_flashlight_on
				if is_flashlight_on:
					flashlight.energy = flashlight_intensity
				else:
					flashlight.energy = 0
