extends CharacterBody2D


@export var speed: float = 300.0

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
