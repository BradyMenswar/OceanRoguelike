extends Node

signal vent_event_started(vent_ref)
signal vent_event_completed(essence_amount)
signal player_spawned(player_ref)
signal tilemap_generated(map_manager_ref)
signal stats_changed()
signal tilemap_changed(map_manager_ref)
signal stage_entered(stage_index: int)
signal stage_completed()
signal object_positions_generated(positions: Array[Vector2], object_type: GameGlobals.Objects)
signal minimap_expand_toggled(minimap_expanded: bool)
signal minimap_objects_reveal(object_types: Array[GameGlobals.Objects])
signal minimap_fog_radius_changed(new_radius: float)
