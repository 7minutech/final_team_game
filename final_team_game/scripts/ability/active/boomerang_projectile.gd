extends RigidBody2D

### Constants ###

### Variables ###
# Variables for targeting
var returning: bool = false
var going: bool = false
var enemyList: Array = []
var auto: bool = false

# Variables for stats
var initial_speed: float
var speed: float
var damage: int

# Variables for shooting
var parent: Weapon
var max_ricochets: int = 0
var current_ricochets: int = 0

# Variables for movement
@export var SPEED_UP_MODIFIER: float = .01
var direction: Vector2
var targetPos: Vector2
var playerPos: Vector2
@onready var sprite: AnimatedSprite2D = $Skin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_speed = speed
	parent.numProj += 1
	if get_tree().current_scene.find_child("Hero"):
		self.position = get_tree().current_scene.find_child("Hero").position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if !$Visibility.is_on_screen():
		goToPlayer()
	
	if going && !auto:
		goToTarget()
	elif returning:
		goToPlayer()
	elif current_ricochets < max_ricochets:
		self.move_and_collide((direction * delta).normalized() * speed)
	'''
	elif !returning && current_ricochets < max_ricochets:
		self.move_and_collide((direction * delta).normalized() * speed)
	elif !returning && !auto:
		goToTarget()
	else:
		goToPlayer()
	'''
	self.move_and_collide((direction * delta).normalized() * speed)

# Function for assigning this projectile a parent
func setParent(p: Weapon) -> void:
	parent = p
func setAuto(flag: bool) -> void:
	auto = flag
	
# Function to set direction of movement
func setDirection(d: Vector2) -> void:
	direction = d
func setTargetPos(pos: Vector2) -> void:
	targetPos = pos

## Functions for stats
# Function for adjusting damage
func setDamage(dmg: int) -> void:
	damage = dmg
# Function for adjusting speed
func setSpeed(spd: int) -> void:
	speed = spd
##
# Function for set the max number of ricochets
func setMaxRicochets(r: int ) -> void:
	max_ricochets = r

## Functions for targeting
func findEnemies() -> void:
	var newList: Array = enemyList.duplicate(true)
	for enemy in newList:
		if enemy.is_inside_tree():
			direction = enemy.global_position - self.global_position
			#print("Current: " + str(current_ricochets) + " || Max: " + str(max_ricochets))
			#print(str(direction))
			speed += 1
			return
		else:
			goToTarget()

func goToTarget() -> void:
	if !going:
		going = true
		returning = false
	direction = targetPos - self.global_position
	speed = speed + (speed * SPEED_UP_MODIFIER)

func goToPlayer() -> void:
	if !returning:
		returning = true
		going = false
		$DamageArea.set_collision_mask_value(2, true)
		$DamageArea.set_collision_mask_value(8, false)
	playerPos = PlayerObserver.player.global_position
	direction = playerPos - self.global_position
	speed = speed + (speed * SPEED_UP_MODIFIER)
	
func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemyList.erase(body)
		body.loseHealth(damage)
		if !returning:
			current_ricochets += 1
			if current_ricochets >= max_ricochets && auto:
				goToPlayer()
			elif current_ricochets <= max_ricochets && !enemyList.is_empty():
				findEnemies()
			else:
				goToTarget()
	if body.is_in_group("Hero"):
		if returning:
			parent.numProj -= 1
			self.queue_free()

func _on_damage_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("boomerang_target"):
		speed = initial_speed
		goToPlayer()
		area.call_deferred("queue_free")



func _on_target_finder_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemyList.append(body)

func _on_target_finder_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemyList.erase(body)


func _on_spin_timeout() -> void:
	$Skin.rotate(deg_to_rad(33))
