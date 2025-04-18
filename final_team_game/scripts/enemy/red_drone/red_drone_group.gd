extends RigidBody2D

class_name RedDrone

### Constants ###
# Constants for preloads
const red_drone = preload("res://scenes/enemy/red_drone/red_drone_2.tscn")
# Constants for spawning logic
const radius: int = -100

### Variables ###
@export var droneCount: int = 10
var direction: Vector2
var speed: int = 7
var frozen: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = CameraObserver.get_random_spawn_position()
	spawn_drones_randomly()
	

func _physics_process(delta: float) -> void:
	move_and_collide((direction * delta).normalized() * speed)
	if self.get_child_count() <= 1:
		#print("drone_group freed")
		self.queue_free()

### Functions for spawn logic ###
# Function to spawn red drones randomly around origin
func spawn_drones_randomly() -> void:
	for num in range(droneCount):
		var drone = red_drone.instantiate()
		self.add_child(drone)
		drone.position = Vector2(randi_range(radius, abs(radius)), randi_range(radius, abs(radius)))

# Function to set the direction that the drones will follow
func setDirection(d: Vector2) -> void:
	direction = d

func freeze(freeze_time: float) -> void:
	if not frozen:
		var speed_before: float = speed
		speed = 0
		frozen = true
		turn_blue()
		await get_tree().create_timer(freeze_time).timeout
		speed = speed_before
		frozen = false
		turn_back()

func turn_blue() -> void:
	var blue_color: Color = Color("#6699FF")
	for drone in get_children():
		if drone is RedDrone:
			drone.sprite.modulate = blue_color

func turn_back() -> void:
	for drone in get_children():
		if drone is RedDrone:
			drone.sprite.modulate = drone.original_color
