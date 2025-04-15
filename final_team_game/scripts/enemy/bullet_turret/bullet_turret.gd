extends Node2D

### Constants ###
# Constants for preloads
const PROJECTILE = preload("res://scenes/enemy/bullet_turret/bullet_turret_projectile.tscn")
# Constants for initial stats
const INITIAL_PROJECTILE_SPEED: int = 7
const INITIAL_BURST_SIZE: int = 3
const INITIAL_DAMAGE: int = 10
const INITIAL_HEALTH: int = 30

### Variables ###
# Variables for shooting logic
var time_tracker: float = 0.0
@export var burst_cooldown: int = 1
var shots_fired: int = 0
var canShoot: bool = true
## Variables for stats
var projectile_speed: int = INITIAL_PROJECTILE_SPEED
var burstSize: int = INITIAL_BURST_SIZE
var fireRate: float = 1.0 / burstSize
var damage: int = INITIAL_DAMAGE
# Health variables
var health: int = INITIAL_HEALTH
var max_health: int = INITIAL_HEALTH
var health_key: String = "turret_health"
var damage_key: String = "turret_damage"
@onready var hit_label: Label = $DamageLabel
@onready var hit_label_animation: AnimationPlayer = $DamageLabel/AnimationPlayer
# Variables for sprite management
@onready var sprite: Sprite2D = $BaseSkin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_max_health()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if $Visibility.is_on_screen():
		$Laser.show()
		if canShoot:
			aim()
			if time_tracker >= fireRate:
				if shots_fired < burstSize:
					shoot()
					time_tracker = 0.0
				else:
					canShoot = false
					shots_fired = 0
			else:
				time_tracker += delta
		else:
			time_tracker += delta
			if time_tracker >= burst_cooldown:
				canShoot = true
				time_tracker = 0.0
	else:
		$Laser.hide()
		time_tracker = 0.0


### Functions to handle shooting logic ###
# Function to aim based on the mouse
func aim() -> void:
	var playerPos: Vector2 = PlayerObserver.player.global_position
	$Laser.look_at(playerPos)
##
# Function to shoot based on player position
func shoot() -> void:
	var playerPos: Vector2 = PlayerObserver.player.global_position
	var projectile = PROJECTILE.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.setDamage(damage)
	projectile.setSpeed(projectile_speed)
	projectile.position = self.global_position
	var direction: Vector2 = playerPos - self.position
	projectile.look_at(playerPos)
	projectile.setDirection(direction)
	shots_fired += 1
##

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
		self.queue_free()
##

func set_pitch_scale() -> void:
	var pitch := randf_range(1.2,1.5)
	$LostHeatlhSound.pitch_scale = pitch

func drop_xp_orb(xp_value: int) -> void:
	var xp_orb: PackedScene = preload("res://scenes/item/xp_orb.tscn")
	var xp_orb_instance: XPOrb2 = xp_orb.instantiate()	
	xp_orb_instance.set_xp_value(xp_value)
	xp_orb_instance.position = self.position
	get_tree().current_scene.call_deferred("add_child", xp_orb_instance)

func flash_white() -> void:
	var original_color: Color = sprite.modulate
	var white: Color = Color(1.5, 1.5, 1.5, 1)
	#creat a tween for half a second white half a second original
	var tween := get_tree().create_tween()
	tween.tween_property(sprite, "modulate", white, 0.05)
	tween.tween_interval(0.05)
	tween.tween_property(sprite, "modulate", original_color, 0.1)

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
