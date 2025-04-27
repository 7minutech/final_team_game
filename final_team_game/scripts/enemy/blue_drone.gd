extends CharacterBody2D

## Constants
# Constants for stats
const INITIAL_HEALTH: int = 20.0
const INITIAL_SPEED: float = 50.0
const INITIAL_DAMAGE: int = 10

## Variables
# Variables for stats
var health: int = INITIAL_HEALTH
var max_health: int = INITIAL_HEALTH
@export var speed: float = INITIAL_SPEED
var damage: int = INITIAL_DAMAGE
var off_screen: bool = false
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite_animation: AnimatedSprite2D = $AnimatedSprite2D
var health_key: String = "blue_drone_health"
var damage_key: String = "blue_drone_damage"
@onready var hit_label: Label = $DamageLabel
@onready var hit_label_animation: AnimationPlayer = $DamageLabel/AnimationPlayer
@onready var original_color: Color = sprite.modulate
var frozen: bool = false
var just_spawned := true


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	just_spawned = false
	set_max_health()
	health = max_health
		
func _physics_process(_delta: float) -> void:
	if PlayerObserver.player != null and not frozen:
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
		drop_xp_orb(20)
		if PlayerObserver.player != null:
			PlayerObserver.player.addOneToKillCounter()
		await get_tree().create_timer(0.15).timeout
		#self.queue_free()
		self.call_deferred("queue_free")

# Function to attack player
func attack(hero: CharacterBody2D) -> void:
	$AttackTimer.start()
	hero.loseHealth(damage)

func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	off_screen = false
	$QueueFreeTimer.stop()
	pass # Replace with function body.

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	off_screen = true
	$QueueFreeTimer.start()
	pass # Replace with function body.

func _on_queue_free_timer_timeout() -> void:
	if off_screen:
		queue_free()
	pass # Replace with function body.

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero") && $AttackTimer.is_stopped() and not frozen:
		attack(body)

func flash_white() -> void:
	#var original_color: Color = sprite.modulate
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
	max_health += EnemyOberver.entity_health_dict[health_key]

func set_damage_health() -> void:
	damage += EnemyOberver.entity_damage_dict[damage_key]
	
func show_hit_number(dmg: int) -> void:
	hit_label_animation.play("hit")
	hit_label.text = str(dmg)
	hit_label.show()
	await get_tree().create_timer(0.2).timeout
	hit_label.hide()

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
