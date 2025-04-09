extends RigidBody2D

## Constants

## Variables
# Variables for stats
var speed: int
var damage: int

var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 300
	self.position = get_tree().current_scene.find_child("Hero").position

# Called every physics process frame
func _physics_process(delta: float) -> void:
	self.move_and_collide((direction * delta).normalized() * speed)
	
	
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

# Function to determine what to do if a body is hit
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		self.queue_free()
		body.loseHealth(damage)
