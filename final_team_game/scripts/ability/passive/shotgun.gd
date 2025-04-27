extends Node2D

const INITIAL_DAMAGE: int = 10
const INITIAL_PROJECTILES: int = 2
const INITIAL_PROJECTILE_SPEED: int = 8
const INITIAL_SHOT_INTERVAL: float = 2.0

@export var plasma_proj: PackedScene
var projectiles := INITIAL_PROJECTILES
var damage := INITIAL_DAMAGE
var projectile_speed := INITIAL_PROJECTILE_SPEED
var shot_interval := INITIAL_SHOT_INTERVAL


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func shoot(projectile_num: int):
	var player_last_direction: String = PlayerObserver.player.last_known_direction
	var base_angle = get_angle_from_direction(player_last_direction)
	var spread = deg_to_rad(45)  # Total spread angle in radians (e.g., 45°)
	var mid_index = (projectile_num - 1) / 2.0  # Center point for even/odd spreads

	for i in range(projectile_num):
		var projectile: PlasmaProjectile = plasma_proj.instantiate()
		projectile.setDamage(damage)
		projectile.setSpeed(projectile_speed)
		get_tree().current_scene.add_child(projectile)

		# Calculate angle offset relative to the center
		var angle_offset = spread * (i - mid_index) / max(projectile_num - 1, 1)
		var shoot_angle = base_angle + angle_offset

		# Convert angle to Vector2 direction
		var shoot_direction = Vector2(cos(shoot_angle), sin(shoot_angle)).normalized()
		projectile.setDirection(shoot_direction)
	pass
	

func get_converted_direction(direction: String) -> Vector2:
	match direction:
		"right":
			return Vector2.RIGHT
		"left":
			return Vector2.LEFT
		"up":
			return Vector2.UP
		"down":
			return Vector2.DOWN
		_:
			return Vector2.RIGHT

func get_angle_from_direction(dir: String) -> float:
	match dir:
		"up": return -PI / 2
		"down": return PI / 2
		"left": return PI
		"right": return 0
	return 0  # Default to right

func _on_shot_interval_timeout() -> void:
	shoot(projectiles)
	pass # Replace with function body.

func set_damage(new_damage: int) -> void:
	damage = new_damage

func set_proj_speed(new_speed: int) -> void:
	projectile_speed = new_speed

func set_proj_num(new_proj_num: int) -> void:
	projectiles = new_proj_num

func set_shot_interval(new_time: float) -> void:
	$ShotInterval.wait_time = new_time
	pass

func update_stat(qty: int) -> void:
	match qty:
		1:
			set_damage(INITIAL_DAMAGE + 5)
		2:
			set_proj_num(INITIAL_PROJECTILES + 2)
		3:
			set_shot_interval(INITIAL_SHOT_INTERVAL - 0.25)
		4:
			set_proj_speed(INITIAL_PROJECTILE_SPEED + 2)
		5:
			set_proj_num(INITIAL_PROJECTILES + 2)
		6:
			set_shot_interval(INITIAL_SHOT_INTERVAL - 0.50)
		7:
			set_damage(INITIAL_DAMAGE + 10)
		8:
			set_proj_speed(INITIAL_PROJECTILE_SPEED + 4)
		9:
			set_proj_num(INITIAL_PROJECTILES + 2)
		_:
			print("Invalid level")
