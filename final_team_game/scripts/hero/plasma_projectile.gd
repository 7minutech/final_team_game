extends RigidBody2D

class_name 	PlasmaProjectile

## Constants

## Variables
# Variables for stats
var speed: int = 5
var damage: int = 20

var direction: Vector2
var damage_key: String = "plasma_projectile_damage"
var speed_key: String = "plasma_projectile_speed"
@onready var sprite: Sprite2D = $Skin
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DamageObserver.weapon_damage_dict[damage_key] = damage
	DamageObserver.weapon_damage_dict[speed_key] = speed
	if get_tree().current_scene.find_child("Hero"):
		self.position = get_tree().current_scene.find_child("Hero").position

# Called every physics process frame
func _physics_process(delta: float) -> void:
	self.move_and_collide((direction * delta).normalized() * speed)

func _process(_delta: float) -> void:
	update()
	
	
# Function to set direction of movement
func setDirection(d: Vector2) -> void:
	direction = d

## Functions for stats
# Function for adjusting speed
func setSpeed(spd: int) -> void:
	speed = spd
##
# Function for adjusting damage
func setDamage(dmg: int) -> void:
	damage = dmg

# Function to despawn the projectile if it does not collide
func _on_despawn_timeout() -> void:
	self.queue_free()

func bullet() -> void:
	pass

func update() -> void:
	damage = DamageObserver.weapon_damage_dict[damage_key]
	speed = DamageObserver.weapon_damage_dict[speed_key]

# Function to determine what to do when a body is hit
func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		self.queue_free()
		body.loseHealth(damage)
