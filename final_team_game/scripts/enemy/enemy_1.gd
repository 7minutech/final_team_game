extends CharacterBody2D

## Constants
# Constants for stats
const INITIAL_HEALTH: int = 10
const INITIAL_SPEED: float = 50.0
const INITIAL_DAMAGE: int = 10

## Variables
# Variables for stats
var health: int = INITIAL_HEALTH
@export var speed: float = INITIAL_SPEED
var damage: int = INITIAL_DAMAGE
var off_screen: bool = false
func _ready() -> void:
	pass
		

func _physics_process(delta: float) -> void:
	if PlayerObserver.player != null:
		$Sprite2D/AnimationPlayer.play("walk")
		var direction = PlayerObserver.player.global_position - global_position
		velocity = direction.normalized() * speed
		
		if health <= 0:
			self.queue_free()
		move_and_slide()
		
### Functions for stats ###
# Function to lose health
func loseHealth(dmg: int) -> void:
	health -= dmg
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
