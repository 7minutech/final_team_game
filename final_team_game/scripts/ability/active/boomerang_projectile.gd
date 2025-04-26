extends RigidBody2D

### Constants ###

### Variables ###
# Variables for targeting
var returning: bool = false
var targetList: Array = []

# Variables for stats
var speed: int = 2
var damage: int = 25

# Variables for shooting
var parent: Weapon
var max_ricochets: int = 0
var current_ricochets: int = 0

# Variables for movement
@export var SPEED_UP_MODIFIER: float = .1
var direction: Vector2
var endPoint: Vector2
@onready var sprite: AnimatedSprite2D = $Skin

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent.numProj += 1
	if get_tree().current_scene.find_child("Hero"):
		self.position = get_tree().current_scene.find_child("Hero").position
		print(str(parent.numProj))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if $Visibility.is_on_screen() && !returning:
		self.move_and_collide((direction * delta).normalized() * speed)
	else:
		goToPlayer()
		self.move_and_collide((direction * delta).normalized() * speed)
	
# Function for assigning this projectile a parent
func setParent(p: Weapon) -> void:
	parent = p

# Function to set direction of movement
func setDirection(d: Vector2) -> void:
	direction = d
func setEndPoint(ep: Vector2) -> void:
	endPoint = ep


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
func findTargets() -> void:
	var newList: Array = targetList.duplicate(true)
	for target in newList:
		if target.is_inside_tree():
			
			if current_ricochets < max_ricochets:
				pass

func goToPlayer() -> void:
	returning = true
	endPoint = PlayerObserver.player.position
	direction = endPoint - self.position
	speed = speed + (speed * SPEED_UP_MODIFIER)
	
func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.loseHealth(damage)
		if current_ricochets < max_ricochets && !returning:
			current_ricochets += 1
			findTargets()
		else:
			goToPlayer()


func _on_target_finder_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targetList.append(body)
		body.is_inside_tree()
	if body.is_in_group("Hero"):
		if returning:
			parent.numProj -= 1
			print(str(parent.numProj))
			self.queue_free()


func _on_target_finder_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targetList.erase(body)
