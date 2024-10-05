extends BaseItem
class_name StatItem

@export var increased_stats := [
	{
		"stat": GameGlobals.Stats.MoveSpeed,
		"amount": 100.0
	}
]

func apply_effects():
	for stat_increase in increased_stats:
		GameGlobals.current_stats[stat_increase.stat] += stat_increase.amount
	GlobalSignal.stats_changed.emit()
