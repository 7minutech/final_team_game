extends Node2D

const LEFT_MAP_LIMIT: int = -5000
const RIGHT_MAP_LIMIT: int = 5000
const TOP_MAP_LIMIT: int = -5000
const BOTTOM_MAP_LIMIT: int = 5000

# Base spawn rates - much faster to start with
const BASE_DRONE_SPAWN_TIME = 3.0  # Faster drone spawning
const BASE_ENEMY_SPAWN_TIME = 2.5  # Faster enemy spawning
const BASE_BOSS_SPAWN_TIME = 20.0  # Bosses appear more frequently
const BASE_RING_ALIEN_SPAWN_TIME = 25.0  # Ring aliens appear more frequently

# Difficulty scaling
const DIFFICULTY_SCALE_RATE = 0.25  # How quickly difficulty increases per level (increased)
const MAX_DIFFICULTY_LEVEL = 10     # Cap the difficulty scaling at this level (lowered to reach max faster)

@onready var spawner: Spawner = $Spawner
@export var spawn_robots: bool = true
@export var spawn_robot_boss: bool = true
@export var spawn_blue_drones: bool = true
@export var spawn_red_drones: bool = true
@export var spawn_alien: bool = true
@export var spawn_braizers: bool = true
@export var spawn_drone_boss: bool = true
@export var spawn_turrets: bool = true

# Level tracking - much faster progression
var level: int = 0
var level_delta: float = 0.0
var level_duration: float = 15.0  # Shorter level duration to progress faster

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StartScreenMusic.stop()
	# Initialize timers with base values
	$BlueDroneTimer.wait_time = BASE_DRONE_SPAWN_TIME
	$RedDroneTimer.wait_time = BASE_DRONE_SPAWN_TIME * 1.2  # Red drones start appearing earlier
	$EnemySpawnTimer.wait_time = BASE_ENEMY_SPAWN_TIME
	$RobotBossTimer.wait_time = BASE_BOSS_SPAWN_TIME
	$DroneBoss.wait_time = BASE_BOSS_SPAWN_TIME * 1.2
	$RingAlienTimer.wait_time = BASE_RING_ALIEN_SPAWN_TIME
	$AlienTimer.wait_time = 4.0  # Aliens appear earlier and more frequently
	
	# Start immediately with basic enemies and drones
	$EnemySpawnTimer.autostart = true
	$BlueDroneTimer.autostart = true
	$AlienTimer.autostart = true  # Aliens start immediately
	
	# First bosses appear quickly
	$RobotBossTimer.start(45.0)  # First boss at 45 seconds
	$DroneBoss.start(90.0)  # Second boss type at 90 seconds
	
	# First ring of aliens appears early
	$RingAlienTimer.start(60.0)  # First ring at 60 seconds
	
	update_game_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	# Track level progress
	level_delta += delta
	
	# Handle player camera and map boundaries
	var player_position = PlayerObserver.player.position
	var camRect: Rect2 = PlayerObserver.player.find_child("HeroCamera").get_viewport_rect()
	
	if player_is_off_map(camRect):
		teleport_player(player_position, camRect)
	
	# Level progression - much faster now
	if level_delta >= level_duration:
		level += 1
		level_delta = 0.0
		
		update_game_state()
		
		# Spawn a boss with each level increase after level 2
		if level >= 2:
			spawn_boss_with_minions()

# Update game difficulty based on current level
func update_game_state() -> void:
	var difficulty_factor = min(level * DIFFICULTY_SCALE_RATE, MAX_DIFFICULTY_LEVEL * DIFFICULTY_SCALE_RATE)
	
	# Update spawn rates - gets intense much faster
	$EnemySpawnTimer.wait_time = max(BASE_ENEMY_SPAWN_TIME * (1.0 - difficulty_factor), 0.4)
	$BlueDroneTimer.wait_time = max(BASE_DRONE_SPAWN_TIME * (1.0 - difficulty_factor), 0.6)
	$AlienTimer.wait_time = max(4.0 * (1.0 - difficulty_factor), 0.8)
	
	# Progressive enemy introductions - happens much faster now
	match level:
		0:  # Starting level - already has enemies and blue drones
			pass
		1:  # 15 seconds in - introduce red drones
			$RedDroneTimer.autostart = true
			$RedDroneTimer.start()
			$RedDroneTimer.wait_time = 2.5
		2:  # 30 seconds in - first ring aliens guaranteed
			spawner.spawn_ring_aliens(40)
		3:  # 45 seconds in - more enemies
			$EnemySpawnTimer.wait_time *= 0.8
			$BlueDroneTimer.wait_time *= 0.8
			$RedDroneTimer.wait_time *= 0.8
		4:  # 60 seconds in - bosses start appearing regularly
			$RobotBossTimer.autostart = true
			$DroneBoss.autostart = true
		5:  # 75 seconds in - even more enemies
			$TurretTimer.start()
			$TurretTimer.autostart = true
			$EnemySpawnTimer.wait_time *= 0.7
			$BlueDroneTimer.wait_time *= 0.7
			$RedDroneTimer.wait_time *= 0.7
			$AlienTimer.wait_time *= 0.7
		8:  # 2 minutes in - intense mode
			$EnemySpawnTimer.wait_time *= 0.6
			$BlueDroneTimer.wait_time *= 0.6
			$RedDroneTimer.wait_time *= 0.6
			$AlienTimer.wait_time *= 0.6
			$RobotBossTimer.wait_time *= 0.8
			$DroneBoss.wait_time *= 0.8
	
	# Every level after 1, trigger a ring of aliens
	if level >= 1:
		$RingAlienTimer.wait_time = max(BASE_RING_ALIEN_SPAWN_TIME * (1.0 - difficulty_factor * 0.5), 12.0)
	
	print("Level ", level, " - Difficulty updated! Enemy Timer: ", $EnemySpawnTimer.wait_time)

# Function to spawn a boss with appropriate minions
func spawn_boss_with_minions() -> void:
	# Alternate between boss types
	if level % 2 == 0:
		# Robot boss with minions
		spawner.spawn("robot_boss")
		# Spawn supporting enemies
		for i in range(min(level, 5)):
			spawner.spawn("robot")
	else:
		# Drone boss with ring aliens
		spawner.spawn("blue_drone_boss")
		spawner.spawn_ring_aliens(40 + min(level * 2, 30))
		
		# Add some extra drones for support
		for i in range(min(level, 4)):
			spawner.spawn("blue_drone")
	
	# At higher levels, spawn both bosses sometimes
	if level >= 6 and randf() < 0.3:
		spawner.spawn("robot_boss")
		spawner.spawn("blue_drone_boss")
		spawner.spawn_ring_aliens(60)

# Function that checks for input events
func _input(event: InputEvent) -> void:
	if event.is_action("pause_game"):
		PlayerObserver.player.updateAllStats()
		PlayerObserver.player.find_child("Hud").setPaused()
		get_tree().set_pause(true)
	if event.is_action("spawn") and OS.is_debug_build():
		spawner.spawn("red_drones")  # Debug-only spawn command

### Timer callbacks ###
func _on_braizer_spawn_timer_timeout() -> void:
	if spawn_braizers:
		spawner.spawn("braizer")

func _on_enemy_spawn_timer_timeout() -> void:
	if spawn_robots:
		# As difficulty increases, spawn multiple robots
		var count = 1 + min(level / 2, 3)
		
		for i in range(count):
			spawner.spawn("robot")

func _on_robot_boss_timer_timeout() -> void:
	if spawn_robot_boss:
		spawner.spawn("robot_boss")
		
		# Spawn some minions with the boss
		for i in range(min(level, 4)):
			spawner.spawn("robot")

func _on_alien_timer_timeout() -> void:
	if spawn_alien:
		var count = 1 + min(level / 3, 2)
		
		for i in range(count):
			spawner.spawn("alien")

func _on_ring_alien_timer_timeout() -> void:
	if spawn_alien:
		# Size of ring increases with level
		var ring_size = 40 + min(level * 3, 30)
		spawner.spawn_ring_aliens(ring_size)

func _on_blue_drone_timer_timeout() -> void:
	if spawn_blue_drones:
		var count = 1 + min(level / 2, 3)
		
		for i in range(count):
			spawner.spawn("blue_drone")

func _on_red_drone_timer_timeout() -> void:
	if spawn_red_drones:
		var count = 1 + min(level / 3, 2)
		
		for i in range(count):
			spawner.spawn("red_drones")

func _on_drone_boss_timeout() -> void:
	if spawn_drone_boss:
		spawner.spawn("blue_drone_boss")
		
		# Spawn a ring of aliens with the boss
		if level >= 2:
			spawner.spawn_ring_aliens(40 + min(level * 2, 20))

func _on_turret_timer_timeout() -> void:
	if spawn_turrets:
		spawner.spawn("bullet_turret")
	pass # Replace with function body.

# Map boundary functions
func player_is_off_map(camRect: Rect2) -> bool:
	var player = PlayerObserver.player
	var center: Vector2 = camRect.get_center()
	if abs(player.position.x) > 5000 - center.x or abs(player.position.y) > 5000 - center.y:
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
