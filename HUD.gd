extends CanvasLayer

var MAX_ENERGY: float

func _ready():
	GlobalSignal.energy_changed.connect(_on_energy_changed)
	%EnergyBarUI.max_value = MAX_ENERGY
	%EnergyBarUI.value = %EnergyBarUI.max_value

func _on_energy_changed(current_amount: float, max_energy: float):
	%EnergyBarUI.value = current_amount
	if MAX_ENERGY != max_energy:
		MAX_ENERGY = max_energy
		%EnergyBarUI.max_value = MAX_ENERGY
		
