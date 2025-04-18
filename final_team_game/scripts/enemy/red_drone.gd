extends RigidBody2D

## Constants
# Constants for stats
const INITIAL_HEALTH: int = 20.0
const INITIAL_SPEED: int = 7
const INITIAL_DAMAGE: int = 10

## Variables
# Variables for stats
var health: int = INITIAL_HEALTH
var max_health: int = INITIAL_HEALTH
@export var speed: float = INITIAL_SPEED
var damage: int = INITIAL_DAMAGE
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var original_color: Color = sprite.modulate
var frozen: bool = false
var direction: Vector2

func _ready() -> void:
	#process_mode = Node.PROCESS_MODE_ALWAYS
	set_max_health()
	health = max_health
	direction = PlayerObserver.player.position - self.position

func _physics_process(delta: float) -> void:
	if not frozen:
		sprite_animation.play("walk")
		self.move_and_collide((direction * delta).normalized() * speed)
		if $QueueFreeTimer.is_stopped() && !$Visibility.is_on_screen():
			self.queue_free()

### Functions for stats ###
# Function to lose health
func loseHealth(dmg: int) -> void:
	set_pitch_scale()
	$LostHeatlhSound.play()
	flash_white()
	health -= dmg
	if health <= 0:
		drop_xp_orb(20)
		if PlayerObserver.player != null:
			PlayerObserver.player.addOneToKillCounter()
		await get_tree().create_timer(0.15).timeout
		self.queue_free()
##

# Function to attack player
func attack(hero: CharacterBody2D) -> void:
	$AttackTimer.start()
	hero.loseHealth(damage)


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

func drop_xp_orb(xp_value: int) -> void:
	var xp_orb: PackedScene = preload("res://scenes/item/xp_orb.tscn")
	var xp_orb_instance: XPOrb2 = xp_orb.instantiate()	
	xp_orb_instance.set_xp_value(xp_value)
	xp_orb_instance.position = self.position
	get_parent().call_deferred("add_child", xp_orb_instance)
	
func set_max_health() -> void:
	max_health += (TimeObserver.total_time / 60.0) * 10
	#print(str((TimeObserver.total_time / 60.0) * 10))
	#print(max_health)

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
		unfreeze_children()

func turn_blue() -> void:
	var blue_color: Color = Color("#6699FF")
	sprite.modulate = blue_color
	
func unfreeze_children() -> void:
	for drone in get_children(): 
		if drone is RedDrone:
			drone.frozen = false
