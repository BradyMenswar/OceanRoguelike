extends Node2D

@onready var refire_timer = $RefireTimer
@onready var bullet_container = $BulletContainer
@onready var barrel_placement = $BarrelPlacement
@export var reactor_component: ReactorComponent

var weapon_resource: Weapon

var bullet_scene = preload("res://bullet.tscn")
var refire_ready: bool = true
var is_overheated: bool = false
var is_shooting: bool = false

func _ready() -> void:
	weapon_resource = GameGlobals.current_weapon
	reactor_component.reactor_overheated.connect(_on_reactor_overheated)
	reactor_component.reactor_cooled.connect(_on_reactor_cooled)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and refire_ready:
		is_shooting = true;
	elif event.is_action_released("shoot"):
		is_shooting = false;


func _process(_delta: float) -> void:
	if is_shooting and refire_ready and  !is_overheated and weapon_resource.firing_mode == Weapon.FiringMode.Semi:
		shoot()
		is_shooting = false;
	elif is_shooting and refire_ready and !is_overheated and weapon_resource.firing_mode == Weapon.FiringMode.Auto:
		shoot()
		
		
func shoot() -> void:
	refire_ready = false
	for bullet_index in range(weapon_resource.bullet_count):
		handle_bullet()
	reactor_component.use(weapon_resource.heat_cost)
	refire_timer.start(1.0 / weapon_resource.fire_rate)


func _on_reactor_overheated() -> void:
	is_overheated = true


func _on_reactor_cooled() -> void:
	is_overheated = false


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
	refire_ready = true
