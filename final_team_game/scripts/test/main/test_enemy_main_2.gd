extends Node2D

const LEFT_MAP_LIMIT: int = -5000
const RIGHT_MAP_LIMIT: int = 5000
const TOP_MAP_LIMIT: int = -5000
const BOTTOM_MAP_LIMIT: int = 5000
const INITIAL_DRONE_SPAWN_TIME = 2.0
const INITIAL_ENEMY_SPAWN_TIME = 2.0

@onready var spawner: Spawner = $Spawner
@export var spawn_robots: bool = true
@export var spawn_robot_boss: bool = true
@export var spawn_blue_drones: bool = true
@export var spawn_red_drones: bool = true
@export var spawn_alien: bool = true
@export var spawn_braizers: bool = true
@export var spwan_drone_boss: bool = true
var just_spawned := true
var level: int = 0
var level_delta: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StartScreenMusic.stop()
	#test
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	level_delta += _delta
	var player_position = PlayerObserver.player.position
	var camRect: Rect2 = PlayerObserver.player.find_child("HeroCamera").get_viewport_rect()
	if level_delta >= 15:
		level += 1
		level_delta = 0.0
	if player_is_off_map(camRect):
		teleport_player(player_position, camRect)
	# Handle BlueDroneTimer and EnemySpawnTimer for levels 1–6
	if level >= 1 and level <= 6:
		$BlueDroneTimer.wait_time = INITIAL_DRONE_SPAWN_TIME - (level * 0.2)
		$EnemySpawnTimer.wait_time = INITIAL_ENEMY_SPAWN_TIME - (level * 0.2)
		if level == 1:
			$EnemySpawnTimer.autostart = true

# Handle RedDroneTimer autostart toggle
	if level == 7:
		$RedDroneTimer.autostart = true
	elif level == 8:
		$RedDroneTimer.autostart = false

	
		
	#spawner.spawn_ring_aliens(60)
	pass

# Function that checks for input events
func _input(event: InputEvent) -> void:
	if event.is_action("pause_game") && !get_tree().paused:
		PlayerObserver.player.updateAllStats()
		PlayerObserver.player.find_child("Hud").setPaused()
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

func player_is_off_map(camRect: Rect2) -> bool:
	var player = PlayerObserver.player
	var center: Vector2 = camRect.get_center()
	if abs(player.position.x) > 5000 -center.x or abs(player.position.y ) > 5000 - center.y:
		return true
	return false

func player_is_off_map_right(x: int) -> bool:
	var player = PlayerObserver.player
	if player.position.x > 5000 - x:
		return true
	return false

func player_is_off_map_left(x: int) -> bool:
	var player = PlayerObserver.player
	if player.position.x < -5000 + x:
		return true
	return false

func player_is_off_map_bottom(y: int) -> bool:
	var player = PlayerObserver.player
	if player.position.y > 5000 - y:
		return true
	return false

func player_is_off_map_top(y: int) -> bool:
	var player = PlayerObserver.player
	if player.position.y < -5000 + y:
		return true
	return false


func teleport_player(player_position: Vector2, camRect: Rect2) -> void:
	var x_offset = camRect.get_center().x
	var y_offset = camRect.get_center().y
	var new_position = player_position

	if player_is_off_map_right(x_offset):
		new_position.x = LEFT_MAP_LIMIT + x_offset
	elif player_is_off_map_left(x_offset):
		new_position.x = RIGHT_MAP_LIMIT - x_offset

	if player_is_off_map_bottom(y_offset):
		new_position.y = TOP_MAP_LIMIT + y_offset
	elif player_is_off_map_top(y_offset):
		new_position.y = BOTTOM_MAP_LIMIT - y_offset

	PlayerObserver.player.position = new_position
