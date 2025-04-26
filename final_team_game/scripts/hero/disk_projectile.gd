extends RigidBody2D

class_name DiskProjectile

## Constants
const INITIAL_REFLECTIONS: int = 2


## Variables
# Variables for stats

var damage: int = 20
var reflections = INITIAL_REFLECTIONS
var remaining_reflections = INITIAL_REFLECTIONS
var speed: float
var direction: Vector2
var damage_key: String = "disk_damage"
var speed_key: String = "disk_speed"
@onready var sprite: Sprite2D = $Skin
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DamageObserver.weapon_damage_dict[damage_key] = damage
	DamageObserver.weapon_damage_dict[speed_key] = speed
	if get_tree().current_scene.find_child("Hero"):
		self.position = get_tree().current_scene.find_child("Hero").position

# Called every physics process frame
func _physics_process(delta: float) -> void:
	# Use the speed variable in movement calculation
	position += (direction * delta * speed)
	
	var player_camera = CameraObserver.player_camera
	var bounced = false
	
	if player_camera:
		# Get camera's viewport rectangle
		var camera_rect = Rect2(
			player_camera.get_screen_center_position() - player_camera.get_viewport_rect().size / 2,
			player_camera.get_viewport_rect().size
		)
		
		# Check if hitting left or right edge of camera view
		if position.x < camera_rect.position.x or position.x > camera_rect.end.x:
			direction = direction.bounce(Vector2(1, 0))
			bounced = true
		
		# Check if hitting top or bottom edge of camera view
		if position.y < camera_rect.position.y or position.y > camera_rect.end.y:
			direction = direction.bounce(Vector2(0, 1))
			bounced = true
	else:
		# Fallback to viewport rect if camera not available
		var screen_size = get_viewport_rect().size
		
		# Check if hitting left or right edge
		if position.x < 0 or position.x > screen_size.x:
			direction = direction.bounce(Vector2(1, 0))
			bounced = true
		
		# Check if hitting top or bottom edge
		if position.y < 0 or position.y > screen_size.y:
			direction = direction.bounce(Vector2(0, 1))
			bounced = true
	
	# Only count down reflections once when bounced
	if bounced:
		$BouceSound.pitch_scale = randf_range(1.1,1.3)
		$BouceSound.play()
		remaining_reflections -= 1
		if remaining_reflections <= 0:
			queue_free()

func _process(_delta: float) -> void:
	#update()
	if remaining_reflections <= 0:
		queue_free()
	
	
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

func set_reflection(num_reflection: int) -> void:
	reflections = num_reflection
	remaining_reflections = reflections

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
		body.loseHealth(damage)
