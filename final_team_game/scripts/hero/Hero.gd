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
const INITIAL_SHIELD_DURATION: float = 0
const INITIAL_SHIELD_CD: float = 5
const ORIGINAL_COLOR: Color = Color("ffffff")
const DEFAULT_WEAPON_KEY = "plasma_gun"

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
var ability_qty: Dictionary = {}
var abilities: Dictionary = {}
var primary_weapon_hash: Dictionary = {}
var movement_buff = 0.05
var health_regen: float 
var pick_up_range: float
var shield_active: bool = false
var shield_duration: float = INITIAL_SHIELD_DURATION
var shield_cd: float = INITIAL_SHIELD_CD
var weapon_slots: Array
var current_weapon_index: int = 0
var primary_weapon: Weapon
var can_drop_ooze: bool = true
var ooze_scene = preload("res://scenes/ability/passive/ooze.tscn")

@onready var original_color: Color = $Skin.modulate
@export var xp_timer: float
@export var radiation_level: int
@export var movement_speed_level: int
@export var max_health_level: int
@export var health_regen_level: int
@export var pick_up_range_level: int
@export var shield_level: int
@export var emp_level: int
@export var default_weapon_level: int = 1
@export var test_gun_level: int
@export var orbital_beam_level: int
@export var ooze_level: int

func _ready() -> void:
	$HurtAnimation.hide()
	$Hud/LevelLabel.text = "Level: " + str(player_level)
	$XPGiver.wait_time = xp_timer
	PlayerObserver.player = self
	AbilityObserver.player = self
	PlayerObserver.max_xp = INITIAL_MAX_XP
	PlayerObserver.player_camera = $HeroCamera
	CameraObserver.player_camera = $HeroCamera
	AbilityObserver.hud = $Hud
	$HealthBar.set_max(INITIAL_HEALTH)
	$HealthBar.set_value_no_signal(INITIAL_HEALTH)
	$Hud/XpBar.max_value = INITIAL_MAX_XP
	AbilityObserver.give_init_abilities()
	$ShieldTimerCD.wait_time = INITIAL_SHIELD_CD
	$ShieldDuration.wait_time = INITIAL_SHIELD_DURATION
	AbilityObserver.hide_all_secondary()
	AbilityObserver.set_primary_weapon(DEFAULT_WEAPON_KEY)
	$EMP.set_boost(true)
	pass
	
func _process(_delta: float) -> void:
	if has_level_up():
		level_up()
	if Input.is_action_just_pressed("hurt"):
		loseHealth(20)
	if swap_pressed():
		$SwapWeaponSound.pitch_scale = randf_range(1.4,1.6)
		$SwapWeaponSound.play()
		if Input.is_action_just_pressed("swap_left"):
			current_weapon_index = left_index(weapon_slots, current_weapon_index)
		elif Input.is_action_just_pressed("swap_right"):
			current_weapon_index = right_index(weapon_slots, current_weapon_index)
		var weapon_instance: Weapon = weapon_slots[current_weapon_index]
		AbilityObserver.set_primary_weapon(weapon_instance.weapon_name)
	if abilities.has("ooze") and can_drop_ooze:
		var main = get_parent()
		var ooze: Ooze = ooze_scene.instantiate()
		can_drop_ooze = false
		$OozeTimer.wait_time = ooze.drop_cd
		$OozeTimer.start()
		main.add_child(ooze)
		ooze.update_stat(ability_qty["ooze"])
		
		
func _physics_process(delta: float) -> void:
		if primary_weapon.weapon_name == "plasma_gun" and abilities.has("test_gun"):
			AbilityObserver.set_primary_weapon("test_gun")
		elif primary_weapon.weapon_name == "test_gun":
			AbilityObserver.set_primary_weapon("plasma_gun")
		else:
			print("Weapon name not in condition for swap hotkey")

func _physics_process(_delta: float) -> void:
	# Check to see if player died
	if health <= 0:
		canShoot = false
		canMove = false
		die()
		
	
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
	if not shield_active:
		show_sparks()
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
	set_random_pitch($LevelUpSound, 0.9, 1.1)
	$LevelUpSound.play()
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
	AbilityObserver.give_random_ability()
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

func set_shield_duration(time: float) -> void:
	shield_duration = time
	$ShieldDuration.wait_time = shield_duration

func set_shield_cd(time: float) -> void:
	if time >= 0:
		shield_cd = time
		$ShieldTimerCD.wait_time = shield_cd

func set_primary_weapon(abilty_key: String) -> void:
	primary_weapon = abilities[abilty_key]

func _on_health_regen_timer_timeout() -> void:
	if health < max_health:
		health += health_regen
		updateHealthBar()
	pass # Replace with function body.


func _on_shield_timer_cd_timeout() -> void:
	$ShieldTimerCD.stop()
	if abilities.has("shield"):
		shield_active = true
	show_shield()
	$ShieldDuration.start()
	pass # Replace with function body.


func _on_shield_duration_timeout() -> void:
	$ShieldDuration.stop()
	shield_active = false
	show_shield()
	$ShieldTimerCD.start()
	pass # Replace with function body.

func show_shield() -> void:
	if shield_active:
		$Skin.modulate = Color("#4ad2ff")
	else:
		$Skin.modulate = ORIGINAL_COLOR

func die():
	get_tree().change_scene_to_file("res://scenes/death_screen.tscn")

func show_sparks() -> void:
	set_random_pitch($HurtSound, 1.2,1.4)
	$HurtSound.play()
	$HurtAnimation.show()
	var yellow: Color = Color("#FFD933")
	$HurtAnimation.play()
	$Skin.modulate = yellow
	await get_tree().create_timer(0.5).timeout
	$Skin.modulate = original_color
	$HurtAnimation.hide()
	$HurtSound.stop()

func set_random_pitch(player: AudioStreamPlayer2D, minimum, maximum) -> void:
	player.pitch_scale = randf_range(minimum,maximum)

func give_health_pickup() -> void:
	var missing_health = max_health - health
	restoreHealth(missing_health)

func give_speed_pickup(multiplier: float) -> void:
	var original_speed: float = speed
	var new_speed = speed * multiplier
	speed = new_speed
	await  get_tree().create_timer(10.0).timeout
	speed = original_speed 
	pass

func give_magnet_pickup(multiplier: float) -> void:
	var shape = $PickUpRange/CollisionShape2D.shape
	var original_radius = shape.radius
	var new_radius = original_radius * multiplier

	var tween = create_tween()
	tween.tween_property(shape, "radius", new_radius, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished

	await get_tree().create_timer(2.0).timeout  
	
	var shrink_tween = create_tween()
	shrink_tween.tween_property(shape, "radius", original_radius, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	await shrink_tween.finished

func give_emp_pickup(multiplier: float) -> void:
	$EMP.expand_boost($EMP.radius * multiplier)
	pass
	
func left_index(arr: Array, index: int) -> int:
	index -= 1
	# if negative wrap to last element
	if index < 0:
		index = arr.size() - 1
	return index
	
func right_index(arr: Array, index: int) -> int:
	index += 1
	# if over wrap to first element
	if index == arr.size():
		index = 0
	return index

func swap_pressed() -> bool:
	return Input.is_action_just_pressed("swap_left") or Input.is_action_just_pressed("swap_right")

func set_arrow_target(chest: Node2D) -> void:
	$Arrow.target_node = chest


func _on_ooze_timer_timeout() -> void:
	can_drop_ooze = true
	pass # Replace with function body.
