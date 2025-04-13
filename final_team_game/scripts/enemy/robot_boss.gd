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
@onready var sprite: Sprite2D = $Sprite2D
@onready var sprite_animation: AnimationPlayer = $Sprite2D/AnimationPlayer
func _ready() -> void:
	set_max_health()
	health = max_health
		

func _physics_process(_delta: float) -> void:
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
	flash_white()
	health -= dmg
	if health <= 0:
		drop_chest()
		if PlayerObserver.player != null:
			PlayerObserver.player.addOneToKillCounter()
		await get_tree().create_timer(0.15).timeout
		self.queue_free()
##

# Function to attack player
func attack(hero: CharacterBody2D) -> void:
	$AttackTimer.start()
	hero.loseHealth(damage)

func player_is_to_left() -> bool:
	return position.x > PlayerObserver.player.postion.x

func player_is_to_right() -> bool:
	return position.x < PlayerObserver.player.postion.x


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	off_screen = false
	pass # Replace with function body.

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	off_screen = true
	pass # Replace with function body.

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero") && $AttackTimer.is_stopped():
		attack(body)

func flash_white() -> void:
	var original_color: Color = sprite.modulate
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
	max_health += (TimeObserver.total_time / 60.0) * 10
	#print(str((TimeObserver.total_time / 60.0) * 10))
	#print(max_health)

func is_off_screen(position: Vector2, camera: Camera2D) -> bool:
	var screen_rect := Rect2(
		camera.global_position - (get_viewport_rect().size * 0.5) * camera.zoom,
		get_viewport_rect().size * camera.zoom
	)
	return not screen_rect.has_point(position)
	
func get_camera_edges(camera: Camera2D) -> Dictionary:
	var viewport_size = get_viewport().get_visible_rect().size
	var zoom = camera.zoom
	var half_width = (viewport_size.x * 0.5) * zoom.x
	var half_height = (viewport_size.y * 0.5) * zoom.y
	
	var cam_pos = camera.global_position

	return {
		"left": cam_pos.x - half_width,
		"right": cam_pos.x + half_width,
		"top": cam_pos.y - half_height,
		"bottom": cam_pos.y + half_height
	}

func get_spawn_left(camera_positions: Dictionary, offset: float) -> Vector2:
	var x_pos: float = camera_positions["left"]
	var y_pos: float = PlayerObserver.player.position.y + offset
	return Vector2(x_pos, y_pos)
	
func get_spawn_right(camera_positions: Dictionary, offset: float) -> Vector2:
	var x_pos: float = camera_positions["right"]
	var y_pos: float = PlayerObserver.player.position.y + offset
	return Vector2(x_pos, y_pos)

func get_spawn_top(camera_positions: Dictionary, offset: float) -> Vector2:
	var x_pos: float = PlayerObserver.player.position.x + offset
	var y_pos: float = camera_positions["top"]
	return Vector2(x_pos, y_pos)
	
func get_spawn_bottom(camera_positions: Dictionary, offset: float) -> Vector2:
	var x_pos: float = PlayerObserver.player.position.x + offset
	var y_pos: float = camera_positions["bottom"]
	return Vector2(x_pos, y_pos)
