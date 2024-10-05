extends Node

@warning_ignore("unused_signal")
signal energy_changed(energy: float, MAX_ENERGY: float)
@warning_ignore("unused_signal")
signal vent_event_started(vent_ref)
@warning_ignore("unused_signal")
signal vent_event_completed(essence_amount)
@warning_ignore("unused_signal")
signal player_spawned(player_ref)
@warning_ignore("unused_signal")
signal tilemap_generated(map_manager_ref)
@warning_ignore("unused_signal")
signal stats_changed()
@warning_ignore("unused_signal")
signal tilemap_changed(map_manager_ref)
@warning_ignore("unused_signal")
signal minimap_expand_toggled(minimap_expanded: bool)
@warning_ignore("unused_signal")
signal stage_completed()
@warning_ignore("unused_signal")
signal object_positions_generated(positions: Array[Vector2], object_type: GameGlobals.Objects)
@warning_ignore("unused_signal")
signal minimap_objects_reveal(object_types: Array[GameGlobals.Objects])
@warning_ignore("unused_signal")
signal stage_entered(stage_index: int)
@warning_ignore("unused_signal")
signal minimap_fog_radius_changed(new_radius: float)
