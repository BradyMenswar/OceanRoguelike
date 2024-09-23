extends Node

signal energy_changed(energy: float, MAX_ENERGY: float)
signal vent_event_started(vent_ref)
signal vent_event_completed(essence_amount)
signal player_spawned(player_ref)
signal tilemap_generated(map_manager_ref)
