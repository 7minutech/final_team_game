extends CharacterBody2D


@export var speed: float = 50.0
var off_screen: bool = false
func _ready() -> void:
	pass
		

func _physics_process(delta: float) -> void:
	if PlayerObserver.player != null:
		$Sprite2D/AnimationPlayer.play("walk")
		var direction = PlayerObserver.player.global_position - global_position
		velocity = direction.normalized() * speed
		move_and_slide()
		

func player_is_to_left() -> bool:
	return position.x > PlayerObserver.player.postion.x

func player_is_to_right() -> bool:
	return position.x < PlayerObserver.player.postion.x


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	off_screen = true
	$QueueFreeTimer.start()
	pass # Replace with function body.


func _on_queue_free_timer_timeout() -> void:
	if off_screen:
		queue_free()
	pass # Replace with function body.


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	off_screen = false
	$QueueFreeTimer.stop()
	pass # Replace with function body.
