extends RigidBody2D

## Constants

## Variables
# Variables for stats
var speed: int
var damage: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 300


# Function to set direction of movement
func setDirection(direction: Vector2) -> void:
	self.set_rotation(self.get_angle_to(direction))
	self.add_constant_force(Vector2(speed,0))

## Functions for stats
# Function for adjusting speed
func setSpeed(spd: int) -> void:
	speed = spd
# Function for adjusting damage
func setDamage(dmg: int) -> void:
	damage = dmg

func _on_despawn_timeout() -> void:
	self.queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemies"):
		self.queue_free()
