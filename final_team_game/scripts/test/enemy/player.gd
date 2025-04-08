extends CharacterBody2D


@export var SPEED: float = 150

func _ready() -> void:
	PlayerObserver.player = self

func _process(delta: float) -> void:
	if velocity != Vector2.ZERO:
		$Sprite2D/AnimationPlayer.play("walk")

func _physics_process(delta: float) -> void:
	var direction: Vector2i
	if Input.is_action_pressed("move_up"):
		direction = Vector2i.UP
	if Input.is_action_pressed("move_down"):
		direction = Vector2i.DOWN
	if Input.is_action_pressed("move_right"):
		direction = Vector2i.RIGHT
	if Input.is_action_pressed("move_left"):
		direction = Vector2i.LEFT
	velocity = direction * SPEED

	move_and_slide()
