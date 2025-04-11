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
func _ready() -> void:
	set_max_health()
	health = max_health
		

func _physics_process(_delta: float) -> void:
	if PlayerObserver.player != null:
		$Sprite2D/AnimationPlayer.play("walk")
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

func player_is_to_left() -> bool:
	return position.x > PlayerObserver.player.postion.x

func player_is_to_right() -> bool:
	return position.x < PlayerObserver.player.postion.x


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
	if body.is_in_group("Hero") && $AttackTimer.is_stopped():
		attack(body)

func flash_white() -> void:
	var original_color: Color = $Sprite2D.modulate
	var white: Color = Color(1.5, 1.5, 1.5, 1)
	#creat a tween for half a second white half a second original
	var tween := get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", white, 0.05)
	tween.tween_interval(0.05)
	tween.tween_property($Sprite2D, "modulate", original_color, 0.1)

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

	
	
