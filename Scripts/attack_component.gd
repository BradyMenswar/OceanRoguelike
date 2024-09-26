extends Node2D

@onready var refire_timer = $RefireTimer
@onready var bullet_container = $BulletContainer
@onready var barrel_placement = $BarrelPlacement

var weapon_resource: Weapon

var bullet_scene = preload("res://bullet.tscn")
var can_shoot: bool = true
var is_shooting: bool = false

func _init() -> void:
	weapon_resource = GameGlobals.current_pilot.starting_weapon

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and can_shoot:
		is_shooting = true;
	elif event.is_action_released("shoot"):
		is_shooting = false;


func _process(_delta: float) -> void:
	if is_shooting and can_shoot and weapon_resource.firing_mode == Weapon.FiringMode.Semi:
		shoot()
		is_shooting = false;
	elif is_shooting and can_shoot and weapon_resource.firing_mode == Weapon.FiringMode.Auto:
		shoot()
		
		
func shoot() -> void:
	can_shoot = false
	for bullet_index in range(weapon_resource.bullet_count):
		handle_bullet()
	refire_timer.start(1.0 / weapon_resource.fire_rate)


func handle_bullet() -> void:
	var current_bullet: Node = bullet_scene.instantiate()
	var bullet_deviance: float = randf_range(-weapon_resource.spread_angle / 2, weapon_resource.spread_angle / 2)

	bullet_container.add_child(current_bullet)

	current_bullet.global_position = barrel_placement.global_position
	current_bullet.global_rotation = global_rotation + deg_to_rad(bullet_deviance)
	current_bullet.rotate(-PI / 2)
	current_bullet.max_range = weapon_resource.max_range
	current_bullet.speed = weapon_resource.shot_speed
	current_bullet.damage = weapon_resource.damage
	
	
func _on_refire_timer_timeout() -> void:
	can_shoot = true
