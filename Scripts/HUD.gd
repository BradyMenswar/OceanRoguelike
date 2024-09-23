extends CanvasLayer

@onready var essence_ui = $EssenceTotal

var max_energy: float
var essence_total: float = 0.0

func _ready() -> void:
	GlobalSignal.energy_changed.connect(_on_energy_changed)
	GlobalSignal.vent_event_completed.connect(_on_vent_event_completed)
	update_essence_ui()
	%EnergyBarUI.max_value = max_energy
	%EnergyBarUI.value = %EnergyBarUI.max_value


func _on_energy_changed(current_amount: float, player_max_energy: float) -> void:
	%EnergyBarUI.value = current_amount
	if max_energy != player_max_energy:
		max_energy = player_max_energy
		%EnergyBarUI.max_value = max_energy


func _on_vent_event_completed(essence_amount) -> void:
	essence_total += essence_amount
	update_essence_ui()


func update_essence_ui() -> void:
	essence_ui.text = "Total Essence: " + str(essence_total) + "/" + str(GameConstants.STAGE_ONE_ESSENCE_REQUIREMENT)
