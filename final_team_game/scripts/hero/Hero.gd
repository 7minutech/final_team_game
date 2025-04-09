extends CharacterBody2D

## Preloads
const PLASMA_PROJ = preload("res://scenes/hero/PlasmaProjectile.tscn")

## Constants
# Constants for initial stats
const INITIAL_PROJECTILE_SPEED: int = 5
const INITIAL_FIRE_RATE: int = 1
const INITIAL_DAMAGE: int = 10
const INITIAL_HEALTH: int = 100
const INITIAL_SPEED: int = 300

## Variables
# Variable for movement logic
var canMove: bool = true
# Variables for shooting logic
var time_tracker: float = 0.0
var canShoot: bool = true
# Variables for stats
var projectile_speed: int = INITIAL_PROJECTILE_SPEED
var fireRate: int = INITIAL_FIRE_RATE
var damage: int = INITIAL_DAMAGE
var health: int = INITIAL_HEALTH
var speed: int = INITIAL_SPEED

func _ready() -> void:
	PlayerObserver.player = self
	$HealthBar.set_max(INITIAL_HEALTH)
	$HealthBar.set_value_no_signal(INITIAL_HEALTH)
	

func _physics_process(delta: float) -> void:
	# Check to see if player died
	if health <= 0:
		canShoot = false
		canMove = false
		get_tree().reload_current_scene()
		
	# Shoot towards mouse position if possible
	if canShoot:
		var mousePos = aim()
		if time_tracker >= fireRate:
			shoot(mousePos)
			time_tracker = 0.0
		else:
			time_tracker += delta
	else:
		time_tracker = 0.0
	
	
	# Handle the hero's movement.
	handleMovement()
	if canMove:
		move_and_slide()

### Functions for stats ###
## Functions for health changes
# Function to lose health
func loseHealth(dmg: int) -> void:
	health -= dmg
	updateHealthBar()
# Function to restore health
func restoreHealth(hp: int) -> void:
	health += hp
	updateHealthBar()
# Function to update HealthBar
func updateHealthBar() -> void:
	$HealthBar.set_value_no_signal(health)
##


# Function to determine the direction that the hero should be facing based on movement
func setFacing() -> void:
	if velocity.x > 0:
		$Skin.flip_h = false
	elif velocity.x < 0:
		$Skin.flip_h = true

# Function to determine how the hero should move based on input
func handleMovement() -> void:
	# Determine which animation to play
	if velocity.x == 0 && velocity.y == 0:
		$Skin.play("Idle")
	else:
		$Skin.play("Walking")

	# Determine left/right movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Determine up/down movement
	direction = Input.get_axis("move_up", "move_down")
	if direction:
		velocity.y = direction * speed
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	setFacing()

## Functions to handle shooting logic ##
# Function to aim based on the mouse
func aim() -> Vector2:
	var mousePos: Vector2 = get_global_mouse_position()
	$AimLine.look_at(mousePos)
	return mousePos
##
# Function to shoot based on mouse position
func shoot(mousePos: Vector2) -> void:
	var projectile = PLASMA_PROJ.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.setDamage(damage)
	projectile.setSpeed(projectile_speed)
	var direction: Vector2 = mousePos - self.position
	projectile.setDirection(direction)
##
# Function to turn shooting off if the mouse is resting on the hero
func _on_mouse_entered() -> void:
	canShoot = false
	
	## Code for confirming functionality
	#print("Mouse entered")
	#print(canShoot)
##
# Function to turn shooting on if the mouse is not on the hero
func _on_mouse_exited() -> void:
	canShoot = true
	
	## Code for confirming functionality
	#print("Mouse exited")
	#print(canShoot)
