extends Node2D


@onready var spawner: Spawner = $Spawner
@export var spawn_robots: bool = true
@export var spawn_robot_boss: bool = true
@export var spawn_blue_drones: bool = true
@export var spawn_red_drones: bool = true
@export var spawn_alien: bool = true
@export var spawn_braizers: bool = true
@export var spwan_drone_boss: bool = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#test
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	#spawner.spawn_ring_aliens(60)
	pass

# Function that checks for input events
func _input(event: InputEvent) -> void:
	if event.is_action("pause_game"):
		PlayerObserver.player.updateAllStats()
		get_tree().set_pause(true)
	if event.is_action("spawn"):
		spawner.spawn("red_drones")


### Functions for timer logic ###
func _on_braizer_spawn_timer_timeout() -> void:
	if spawn_braizers:
		spawner.spawn("braizer")
##
func _on_enemy_spawn_timer_timeout() -> void:
	if spawn_robots:
		spawner.spawn("robot")
##
func _on_robot_boss_timer_timeout() -> void:
	if spawn_robot_boss:
		spawner.spawn("robot_boss")
##
func _on_alien_timer_timeout() -> void:
	if spawn_alien:
		spawner.spawn("alien")
##
func _on_ring_alien_timer_timeout() -> void:
	if spawn_alien:
		spawner.spawn_ring_aliens(60)
##
func _on_blue_drone_timer_timeout() -> void:
	if spawn_blue_drones:
		spawner.spawn("blue_drone")
##
func _on_red_drone_timer_timeout() -> void:
	if spawn_red_drones:
		spawner.spawn("red_drones")
##


func _on_drone_boss_timeout() -> void:
	if spwan_drone_boss:
		spawner.spawn("blue_drone_boss")
	pass # Replace with function body.
