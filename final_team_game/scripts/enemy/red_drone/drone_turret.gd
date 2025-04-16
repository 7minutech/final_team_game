extends Node2D

### Constants ###
# Constants for preloads
const PROJECTILE = preload("res://scenes/enemy/red_drone/red_drone_group.tscn")

### Variables ###
# Variables for shooting logic
var canShoot: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if canShoot:
		shoot()
		canShoot = false

### Functions to handle shooting logic ###
# Function to shoot based on player position
func shoot() -> void:
	var playerPos: Vector2 = PlayerObserver.player.global_position
	var projectile = PROJECTILE.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.position = self.global_position
	var direction: Vector2 = playerPos - self.position
	projectile.setDirection(direction)
##


func _on_queue_free_timer_timeout() -> void:
	self.queue_free()
