extends Node

const STAGE_ONE_ESSENCE_REQUIREMENT: float = 300.0

var current_pilot: Pilot = load("res://Pilots/ar_pilot.tres")
var run_seed = 12345

var tile_size = 256
var tile_scale = 0.5

var minimap_expanded: bool = false
