extends CanvasLayer

var MAX_ENERGY: float
var essence_total := 0.0
@onready var essence_ui = $EssenceTotal

func _ready():
	GlobalSignal.energy_changed.connect(_on_energy_changed)
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)
	update_essence_ui()
	%EnergyBarUI.max_value = MAX_ENERGY
	%EnergyBarUI.value = %EnergyBarUI.max_value

func _on_energy_changed(current_amount: float, max_energy: float):
	%EnergyBarUI.value = current_amount
	if MAX_ENERGY != max_energy:
		MAX_ENERGY = max_energy
		%EnergyBarUI.max_value = MAX_ENERGY
		
func _on_vent_event_completed(essence_amount):
	essence_total += essence_amount
	update_essence_ui()

func update_essence_ui():
	essence_ui.text = "Total Essence: " + str(essence_total) + "/" + str(GameConstants.STAGE_ONE_ESSENCE_REQUIREMENT)
	
