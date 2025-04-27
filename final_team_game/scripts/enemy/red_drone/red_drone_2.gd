extends RigidBody2D

### Variables ###
# Variables for sprite managment
@onready var sprite: AnimatedSprite2D = $Skin
var damage: int = 3
# Health variables
var max_health: int = 10
var health: int = max_health
@onready var original_color = $Skin.modulate
var frozen: bool = false
var just_spawned := true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	just_spawned = false
	$Skin.play("walk")
	pass

func _physics_process(_delta: float) -> void:
	if !$Visibility.is_on_screen() && $QueueFreeTimer.is_stopped():
		#print("drone freed")
		self.call_deferred("queue_free")

### Functions for stats ###
# Function to lose health
func loseHealth(dmg: int) -> void:
	set_pitch_scale()
	$LostHeatlhSound
	flash_white()
	health -= dmg
	if health <= 0:
		$DamageArea2/CollisionShape2D.set_deferred("disabled",true)
		drop_xp_orb(5)
		if PlayerObserver.player != null:
			PlayerObserver.player.addOneToKillCounter()
		await get_tree().create_timer(0.15).timeout
		self.queue_free()
##

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
	xp_orb_instance.global_position = self.global_position
	get_tree().current_scene.call_deferred("add_child", xp_orb_instance)


func _on_damage_area_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero") && $AttackCooldown.is_stopped() and not frozen:
		$AttackCooldown.start()
		body.loseHealth(damage)

func freeze(freeze_time: float) -> void:
	frozen = true
	get_parent().freeze(freeze_time)
