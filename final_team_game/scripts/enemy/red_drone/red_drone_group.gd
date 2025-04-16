extends RigidBody2D

### Constants ###
# Constants for preloads
const red_drone = preload("res://scenes/enemy/red_drone/red_drone_2.tscn")
# Constants for spawning logic
const radius: int = -100

### Variables ###
@export var droneCount: int = 10
var direction: Vector2
var speed: int = 7



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = CameraObserver.get_random_spawn_position()
	spawn_drones_randomly()
	var playerPos: Vector2 = PlayerObserver.player.global_position
	#look_at(playerPos)
	direction = playerPos - self.global_position
	print(str(direction))
	#print(str(global_position))


func _physics_process(delta: float) -> void:
	move_and_collide((direction * delta).normalized() * speed)
	if self.get_child_count() <= 1:
		self.queue_free()

### Functions for spawn logic ###
# Function to spawn red drones randomly around origin
func spawn_drones_randomly() -> void:
	for num in range(droneCount):
		var drone = red_drone.instantiate()
		self.add_child(drone)
		drone.position = Vector2(randi_range(radius, abs(radius)), randi_range(radius, abs(radius)))
		
