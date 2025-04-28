extends Node2D

const LEFT_MAP_LIMIT: int = -5000
const RIGHT_MAP_LIMIT: int = 5000
const TOP_MAP_LIMIT: int = -5000
const BOTTOM_MAP_LIMIT: int = 5000

# Base spawn rates - moderate start but quicker ramp-up
const BASE_DRONE_SPAWN_TIME = 6.0  # Initial drone spawning rate
const BASE_ENEMY_SPAWN_TIME = 5.0  # Initial enemy spawning rate
const BASE_BOSS_SPAWN_TIME = 90.0  # First boss appears around 1.5 minutes
const BASE_RING_ALIEN_SPAWN_TIME = 60.0  # Ring aliens are special events
const BASE_TURRET_SPAWN_TIME = 30.0  # Turrets appear occasionally
const BASE_BRAIZER_SPAWN_TIME = 30.0  # Power-ups every 30 seconds

# Difficulty scaling for 7-minute game
const DIFFICULTY_SCALE_RATE = 0.15  # Faster difficulty increase for shorter game
const MAX_DIFFICULTY_LEVEL = 10    # Cap for shorter progression curve

@onready var spawner: Spawner = $Spawner
@export var spawn_robots: bool = true
@export var spawn_robot_boss: bool = true
@export var spawn_blue_drones: bool = true
@export var spawn_red_drones: bool = true
@export var spawn_alien: bool = true
@export var spawn_braizers: bool = true
@export var spawn_drone_boss: bool = true
@export var spawn_turrets: bool = true

# Level tracking - shorter levels for 7 minute game 
var level: int = 0
var level_delta: float = 0.0
var level_duration: float = 45.0  # 45 seconds per level = ~7 levels in ~5.5 minutes before final chaos
var game_ended: bool = false
# Game time tracking for final stage
var total_game_time: float = 0.0
var final_stage_started: bool = false
const FINAL_STAGE_TIME: float = 360  # 6 minutes before final stage
const TOTAL_GAME_DURATION: float = 420  # 7 minutes total

# Swarm tracking for red drones
var red_drone_swarm_active: bool = false
var red_drone_swarm_cooldown: float = 45.0
var red_drone_swarm_timer: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	StartScreenMusic.stop()
	# Initialize timers with base values
	$BlueDroneTimer.wait_time = BASE_DRONE_SPAWN_TIME
	$RedDroneTimer.wait_time = BASE_DRONE_SPAWN_TIME * 1.5  # Red drones appear later
	$EnemySpawnTimer.wait_time = BASE_ENEMY_SPAWN_TIME
	$RobotBossTimer.wait_time = BASE_BOSS_SPAWN_TIME
	$DroneBoss.wait_time = BASE_BOSS_SPAWN_TIME * 1.2
	$RingAlienTimer.wait_time = BASE_RING_ALIEN_SPAWN_TIME
	$AlienTimer.wait_time = 12.0  # Aliens appear after some time
	$TurretTimer.wait_time = BASE_TURRET_SPAWN_TIME
	$BraizerSpawnTimer.wait_time = BASE_BRAIZER_SPAWN_TIME
	
	# Start with basic enemies
	$EnemySpawnTimer.autostart = true
	
	# Delayed start for drones
	$BlueDroneTimer.start(15.0)  # Blue drones appear after 15 seconds
	
	# First boss appears later
	$RobotBossTimer.start(BASE_BOSS_SPAWN_TIME)
	
	# Start braizer spawns
	$BraizerSpawnTimer.autostart = true
	
	update_game_state()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if PlayerObserver.permanent_upgrade["twice"] == PlayerObserver.upgrade_type.ON:
		delta *= 2
	# Track game time
	total_game_time += delta
	
	# Track level progress
	level_delta += delta
	
	# Track red drone swarm cooldown
	if red_drone_swarm_timer > 0:
		red_drone_swarm_timer -= delta
	
	# Handle player camera and map boundaries
	var player_position = PlayerObserver.player.position
	var camRect: Rect2 = PlayerObserver.player.find_child("HeroCamera").get_viewport_rect()
	
	if player_is_off_map(camRect):
		teleport_player(player_position, camRect)
	
	# Check for final stage - last minute chaos
	if total_game_time >= FINAL_STAGE_TIME and not final_stage_started:
		trigger_final_stage()
		final_stage_started = true
	
	if total_game_time >= TOTAL_GAME_DURATION and not game_ended:
		game_ended = true
		end_game()
	
	# Level progression
	if level_delta >= level_duration:
		level += 1
		level_delta = 0.0
		
		update_game_state()
		
		# Special events based on level
		if level == 2 or level == 4 or level == 6:  # Three boss events during the game
			spawn_boss_with_minions()
		
		if level == 3 or level == 5:  # Two drone swarm events during the game
			trigger_red_drone_swarm()
	if Input.is_action_just_pressed("pause_game") && !get_tree().paused:
		PlayerObserver.player.updateAllStats()
		PlayerObserver.player.find_child("Hud").setPaused()
		get_tree().set_pause(true)

# Final stage - extreme difficulty for the last minute
func trigger_final_stage() -> void:
	print("FINAL STAGE ACTIVATED - MAXIMUM DIFFICULTY!")
	
	# Make everything spawn very quickly
	$EnemySpawnTimer.wait_time = 1.5
	$BlueDroneTimer.wait_time = 1.8
	$RedDroneTimer.wait_time = 2.0
	$AlienTimer.wait_time = 2.5
	$TurretTimer.wait_time = 5.0
	
	# Immediate boss and ring aliens
	spawner.spawn("robot_boss")
	spawner.spawn("blue_drone_boss")
	spawner.spawn_ring_aliens(60)
	
	# Schedule another boss wave halfway through final minute
	get_tree().create_timer(30.0).timeout.connect(func():
		if total_game_time < TOTAL_GAME_DURATION:
			spawner.spawn("robot_boss")
			spawner.spawn_ring_aliens(70)
	)
	
	# Red drone swarm
	trigger_red_drone_swarm()
	
	# Schedule another swarm for 20 seconds in
	get_tree().create_timer(20.0).timeout.connect(func():
		if total_game_time < TOTAL_GAME_DURATION:
			trigger_red_drone_swarm()
	)

# Update game difficulty based on current level
func update_game_state() -> void:
	var difficulty_factor = min(level * DIFFICULTY_SCALE_RATE, MAX_DIFFICULTY_LEVEL * DIFFICULTY_SCALE_RATE)
	
	# Update spawn rates
	$EnemySpawnTimer.wait_time = max(BASE_ENEMY_SPAWN_TIME * (1.0 - difficulty_factor), 2.0)
	$BlueDroneTimer.wait_time = max(BASE_DRONE_SPAWN_TIME * (1.0 - difficulty_factor), 2.5)
	
	# Progressive enemy introductions
	match level:
		0:  # Starting level - just basic robots
			pass
		1:  # 45 seconds in - blue drones already active, introduce aliens
			$AlienTimer.autostart = true
			$AlienTimer.start()
		2:  # 1.5 minutes in - introduce turrets and red drones
			$TurretTimer.autostart = true
			$TurretTimer.start()
			$RedDroneTimer.autostart = true
			$RedDroneTimer.start()
		3:  # 2.25 minutes in - introduce ring aliens
			$RingAlienTimer.autostart = true
			$RingAlienTimer.start()
		4:  # 3 minutes in - drone bosses start appearing
			$DroneBoss.autostart = true
			$DroneBoss.start()
			# Increase spawn rates
			$EnemySpawnTimer.wait_time *= 0.8
			$BlueDroneTimer.wait_time *= 0.8
			$RedDroneTimer.wait_time *= 0.8
		5:  # 3.75 minutes in - higher difficulty
			$EnemySpawnTimer.wait_time *= 0.8
			$BlueDroneTimer.wait_time *= 0.8
			$RedDroneTimer.wait_time *= 0.8
			$RobotBossTimer.wait_time *= 0.8
			$DroneBoss.wait_time *= 0.8
		6:  # 4.5 minutes in - prepare for final stage
			$EnemySpawnTimer.wait_time *= 0.7
			$BlueDroneTimer.wait_time *= 0.7
			$RedDroneTimer.wait_time *= 0.7
	
	print("Level ", level, " - Difficulty updated! Enemy Timer: ", $EnemySpawnTimer.wait_time)

# Function to spawn a boss with appropriate minions
func spawn_boss_with_minions() -> void:
	# Alternate between boss types
	if level % 2 == 0:
		# Robot boss with minions
		spawner.spawn("robot_boss")
		# Spawn supporting enemies (scaled by level but capped)
		for i in range(min(level / 2 + 1, 3)):
			spawner.spawn("robot")
	else:
		# Drone boss with ring aliens
		spawner.spawn("blue_drone_boss")
		spawner.spawn_ring_aliens(30 + min(level * 5, 30))  # Ring size scales with level
	
	# At level 6, spawn both bosses for a challenging encounter
	if level >= 6:
		spawner.spawn("robot_boss")
		spawner.spawn("blue_drone_boss")
		spawner.spawn_ring_aliens(50)

# Function to trigger red drone swarms
func trigger_red_drone_swarm() -> void:
	if red_drone_swarm_timer <= 0 and spawn_red_drones:
		red_drone_swarm_active = true
		red_drone_swarm_timer = red_drone_swarm_cooldown
		
		# Spawn a swarm of 3-4 red drones quickly
		var swarm_size = 3 + min(level / 3, 2)  # 3-5 drones based on level
		for i in range(swarm_size):
			spawner.spawn("red_drones")
		
		# Schedule 3-4 more waves
		for wave in range(4):
			get_tree().create_timer(1.5 + wave * 1.2).timeout.connect(func():
				if spawn_red_drones:
					for i in range(swarm_size - min(wave, 2)):  # Diminishing waves
						spawner.spawn("red_drones")
			)
		
		# Reset swarm state after the event
		get_tree().create_timer(8.0).timeout.connect(func():
			red_drone_swarm_active = false
		)

func end_game() -> void:
	for child in self.get_children():
		if child.is_in_group("enemies"):
			child.queue_free()
	stop_all_timers()
	spawner.spawn("alien_boss")

### Timer callbacks ###
func _on_braizer_spawn_timer_timeout() -> void:
	if spawn_braizers:
		spawner.spawn("braizer")

func _on_enemy_spawn_timer_timeout() -> void:
	if spawn_robots:
		# As level increases, occasionally spawn multiple robots
		var count = 1
		if level >= 3 and randf() < 0.4:
			count += 1
		if level >= 5 and randf() < 0.4:
			count += 1
		
		for i in range(count):
			spawner.spawn("robot")

func _on_robot_boss_timer_timeout() -> void:
	if spawn_robot_boss:
		spawner.spawn("robot_boss")
		
		# Spawn some minions with the boss
		for i in range(min(level / 2, 3)):
			spawner.spawn("robot")

func _on_alien_timer_timeout() -> void:
	if spawn_alien:
		var count = 1
		if level >= 4 and randf() < 0.4:
			count += 1
		
		for i in range(count):
			spawner.spawn("alien")

func _on_ring_alien_timer_timeout() -> void:
	if spawn_alien:
		# Size of ring increases with level
		var ring_size = 25 + min(level * 5, 30)
		spawner.spawn_ring_aliens(ring_size)

func _on_blue_drone_timer_timeout() -> void:
	if spawn_blue_drones:
		var count = 1
		if level >= 3 and randf() < 0.4:
			count += 1
		if level >= 5 and randf() < 0.3:
			count += 1
		
		for i in range(count):
			spawner.spawn("blue_drone")

func _on_red_drone_timer_timeout() -> void:
	if spawn_red_drones and not red_drone_swarm_active:
		var count = 1
		if level >= 4 and randf() < 0.3:
			count += 1
		
		for i in range(count):
			spawner.spawn("red_drones")

func _on_drone_boss_timeout() -> void:
	if spawn_drone_boss:
		spawner.spawn("blue_drone_boss")
		
		# Spawn a ring of aliens with the boss
		if level >= 3:
			spawner.spawn_ring_aliens(30 + min(level * 5, 30))

func _on_turret_timer_timeout() -> void:
	if spawn_turrets:
		spawner.spawn("bullet_turret")
		
		# At higher levels, occasionally spawn 2 turrets
		if level >= 5 and randf() < 0.4:
			get_tree().create_timer(1.0).timeout.connect(func():
				if spawn_turrets:
					spawner.spawn("bullet_turret")
			)

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

func stop_all_timers() -> void:
	for child in get_children():
		if child is Timer:
			child.stop()
	
