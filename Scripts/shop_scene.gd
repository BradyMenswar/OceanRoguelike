extends Control

signal currency_changed(amount: int)
var game_scene = "res://Levels/main_scene.tscn"
@onready var currency_amount_label = $Currency/Amount

func _ready() -> void:
	currency_amount_label.text = str(GameGlobals.current_currency)
	currency_changed.connect(_on_currency_changed)

func _on_next_level_pressed() -> void:
	GameGlobals.current_stage += 1
	get_tree().change_scene_to_file(game_scene)
	
func _on_currency_changed(amount: int) -> void:
	currency_amount_label.text = str(amount)
	
