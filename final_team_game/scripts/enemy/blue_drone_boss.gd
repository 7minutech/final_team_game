extends CharacterBody2D

## Constants
# Constants for stats
const INITIAL_HEALTH: int = 200.0
const INITIAL_SPEED: float = 50.0
const INITIAL_DAMAGE: int = 25

## Variables
# Variables for stats
var health: int = INITIAL_HEALTH
var max_health: int = INITIAL_HEALTH
@export var speed: float = INITIAL_SPEED
var damage: int = INITIAL_DAMAGE
var off_screen: bool = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit_label: Label = $DamageLabel
@onready var hit_label_animation: AnimationPlayer = $DamageLabel/AnimationPlayer
@onready var original_color: Color = sprite.modulate
var frozen: bool = false
var screen_exited_at: String
var health_key: String = "robot_boss_health"
var damage_key: String = "robot_boss_damage"
var just_spawned := true

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	just_spawned = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_max_health()
	health = max_health

func _physics_process(_delta: float) -> void:
	if not frozen:
		if PlayerObserver.player != null:
			sprite_animation.play("walk")
			var direction = PlayerObserver.player.global_position - global_position
			velocity = direction.normalized() * speed	
		move_and_slide()
		
### Functions for stats ###
# Function to lose health
func loseHealth(dmg: int) -> void:
	set_pitch_scale()
	$LostHeatlhSound.play()
	show_hit_number(dmg)
	flash_white()
	health -= dmg
	if health <= 0:
		drop_chest()
		if PlayerObserver.player != null:
			PlayerObserver.player.addOneToKillCounter()
		await get_tree().create_timer(0.15).timeout
		self.queue_free()

# Function to attack player
func attack(hero: CharacterBody2D) -> void:
	$AttackTimer.start()
	hero.loseHealth(damage)

func teleport_to_player(screen_exit: String) -> void:
	var offset: float = randf_range(-370,370)
	var new_position: Vector2
	if screen_exit == "left":
		new_position = CameraObserver.get_spawn_left_offscreen(offset,-50)
		position = new_position
	elif screen_exit == "right":
		new_position = CameraObserver.get_spawn_right_offscreen(offset,-50)
		position = new_position
	elif screen_exit == "top":
		new_position = CameraObserver.get_spawn_top_offscreen(offset,-50)
		position = new_position
	elif screen_exit == "bottom":
		new_position = CameraObserver.get_spawn_bottom_offscreen(offset,-50)
		position = new_position

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	off_screen = false
	$OffScreenTimer.stop()
	pass # Replace with function body.

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:	
	off_screen = true
	$OffScreenTimer.start()
	pass # Replace with function body.

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero") && $AttackTimer.is_stopped() and not frozen:
		attack(body)

func flash_white() -> void:
	var white: Color = Color(1.5, 1.5, 1.5, 1)
	#creat a tween for half a second white half a second original
	var tween := get_tree().create_tween()
	tween.tween_property(sprite, "modulate", white, 0.05)
	tween.tween_interval(0.05)
	tween.tween_property(sprite, "modulate", original_color, 0.1)

func set_pitch_scale() -> void:
	var pitch := randf_range(1.2,1.5)
	$LostHeatlhSound.pitch_scale = pitch

func drop_chest() -> void:
	var chest_scene: PackedScene = preload("res://scenes/item/chest.tscn")
	var chest_instance: Chest = chest_scene.instantiate()	
	chest_instance.position = self.position
	get_parent().call_deferred("add_child", chest_instance)

func set_max_health() -> void:
	max_health += EnemyOberver.entity_health_dict[health_key]

func set_damage_health() -> void:
	damage += EnemyOberver.entity_damage_dict[damage_key]

func show_hit_number(dmg: int) -> void:
	hit_label_animation.play("hit")
	hit_label.text = str(dmg)
	hit_label.show()
	await get_tree().create_timer(0.2).timeout
	hit_label.hide()

func _on_off_screen_timer_timeout() -> void:
	teleport_to_player(get_screen_exit())
	pass # Replace with function body.

func freeze(freeze_time: float) -> void:
	if not frozen:
		var speed_before: float = speed
		speed = 0
		frozen = true
		sprite_animation.stop()
		turn_blue()
		await get_tree().create_timer(freeze_time).timeout
		speed = speed_before
		frozen = false
		sprite.modulate = original_color

func turn_blue() -> void:
	var blue_color: Color = Color("#6699FF")
	sprite.modulate = blue_color

func get_screen_exit() -> String:
	var closest_position = INF
	var screen_exited_at = ""
	var obj_pos = position
	for key in CameraObserver.camera_positions:
		var edge_pos
		match key:
			"left":
				edge_pos = Vector2(CameraObserver.camera_positions[key], obj_pos.y)
			"right":
				edge_pos = Vector2(CameraObserver.camera_positions[key], obj_pos.y)
			"top":
				edge_pos = Vector2(obj_pos.x, CameraObserver.camera_positions[key])
			"bottom":
				edge_pos = Vector2(obj_pos.x, CameraObserver.camera_positions[key])
		var distance = obj_pos.distance_to(edge_pos)
		if distance < closest_position:
			closest_position = distance
			screen_exited_at = key
	return screen_exited_at
	
