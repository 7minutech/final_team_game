extends CharacterBody2D

class_name Player

## Preloads
const PLASMA_PROJ = preload("res://scenes/hero/PlasmaProjectile.tscn")

### Constants ###
# Constants for initial stats
const INITIAL_FIRE_RATE: int = 1
const INITIAL_SPEED: int = 300
const INITIAL_HEALTH: int = 100
const INITIAL_MAX_XP: int = 100
const INITIAL_HEALTH_REGEN: int = 0 
const INITIAL_PICK_UP_RANGE: float = 73.25

### Variables ###
# Variable for movement logic
var canMove: bool = true
# Variables for shooting logic
var time_tracker: float = 0.0
var canShoot: bool = true
## Variables for stats
var killCount: int = 0
var fireRate: int = INITIAL_FIRE_RATE
var speed: int = INITIAL_SPEED
# Health variables
var health: int = INITIAL_HEALTH
var max_health: int = INITIAL_HEALTH
# Xp variables	
var current_xp: int = 0
var max_xp: int = INITIAL_MAX_XP
var player_level: int = 0
var luck: int = 5
var ability_qty: Dictionary
var abilities: Dictionary
var movement_buff = 0.05
var health_regen: float 
var pick_up_range: float
@export var xp_timer: float
@export var garlic_level: int
@export var movement_speed_level: int
@export var max_health_level: int
@export var health_regen_level: int
@export var pick_up_range_level: int
func _ready() -> void:
	$Hud/LevelLabel.text = "Level: " + str(player_level)
	$XPGiver.wait_time = xp_timer
	PlayerObserver.player = self
	PlayerObserver.max_xp = INITIAL_MAX_XP
	PlayerObserver.player_camera = $HeroCamera
	CameraObserver.player_camera = $HeroCamera
	AbilityObserver.player = self
	$HealthBar.set_max(INITIAL_HEALTH)
	$HealthBar.set_value_no_signal(INITIAL_HEALTH)
	$Hud/XpBar.max_value = INITIAL_MAX_XP
	AbilityObserver.give_init_abilities()
	
func _process(_delta: float) -> void:
	if has_level_up():
		level_up()

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
# Function to increase players max health
func raise_player_max_hp() -> void:
	max_health *= 1.1
	$HealthBar.set_max(max_health)
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


### Functions for movment based logic ###
# Function to determine the direction that the hero should be facing based on movement
func setFacing() -> void:
	if velocity.x > 0:
		$Skin.flip_h = false
	elif velocity.x < 0:
		$Skin.flip_h = true
##
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
##

### Functions to handle kill counter logic ###
# Function to add 1 kill to the kill count
func addOneToKillCounter() -> void:
	killCount += 1
	updateKillCounter()
##
# Function to update the kill counter
func updateKillCounter() -> void:
	$Hud/KillCounter.set_text(str(killCount))
##


### Functions to handle shooting logic ###
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
##


### Functions to handle logic for player leveling ###
# Function to determine if the player has leveled up
func has_level_up() -> bool:
	return current_xp >= max_xp
##
# Function to increase player's level by one and adjust stats/labels accordingly
func level_up() -> void:
	print(max_health)
	raise_player_max_xp()
	current_xp = 0
	updateXpBar()
	raise_player_max_hp()
	health = max_health
	updateHealthBar()
	player_level += 1
	$Hud/LevelLabel.text = "Level: " + str(player_level)
	PlayerObserver.current_xp = current_xp
	PlayerObserver.max_xp = max_xp
##
# Function to raise the player's max xp
func raise_player_max_xp() -> void:
	max_xp *= 1.5
	$Hud/XpBar.set_max(max_xp)
# Function to give the player xp on a timer
func _on_xp_giver_timeout() -> void:
	current_xp += 0
	PlayerObserver.current_xp = current_xp
	updateXpBar()
##
# Function to give the player xp when they pick up an orb
func give_xp(xp_orb: XPOrb2):
	current_xp += xp_orb.xp_value
	PlayerObserver.current_xp = current_xp
	updateXpBar()
##
# Function to update the player xp bar
func updateXpBar() -> void:
	$Hud/XpBar.value = current_xp
##

# Function to update player observer with all of the player's stats
func updateAllStats() -> void:
	PlayerObserver.max_hp = max_health
	PlayerObserver.current_hp = health
	PlayerObserver.max_xp = max_xp
	PlayerObserver.current_xp = current_xp
	PlayerObserver.current_level = player_level
	
func _on_ability_tester_timeout() -> void:
	AbilityObserver.give_active_ability("garlic")
	pass # Replace with function body.
	
func set_speed(new_speed: float) -> void:
	speed = new_speed

func set_max_health(new_health: int) -> void:
	max_health = new_health

func set_health_regen(regen: int) -> void:
	health_regen = regen

func set_pick_up_range(new_radius: float) -> void:
	pick_up_range = new_radius
	$PickUpRange/CollisionShape2D.shape.radius = pick_up_range
	var f = $PickUpRange/CollisionShape2D.shape.radius
	print()

func _on_health_regen_timer_timeout() -> void:
	if health < max_health:
		health += health_regen
		updateHealthBar()
	pass # Replace with function body.
