extends Area2D

class_name EMP

var max_qty: float = 6
const INITIAL_RADIUS = 50
var radius: float
var expanded_radius: float
var damage: int = 20
var damage_targets = []
var TICK_INTERVAL: float = 1.0
var tick_timer: float = 0.0
var active = true
var freeze_time: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.hide()
	radius = $CollisionShape2D.shape.radius
	update_sprite_scale()

func update_sprite_scale():
	var circle:CircleShape2D = $CollisionShape2D.shape 
	var newRadius = circle.radius

	#size of sprite
	var tex_size = $Sprite2D.texture.get_size()

	#scale sprite to match circle's diameter
	$Sprite2D.scale = Vector2(newRadius * 2, newRadius * 2) / tex_size

func update_stat(qty:float) -> void:
	# 1 -> 1.2
	# 2 -> 1.4
	var multiplier: float = 1 + (2 * (qty / 10))
	expanded_radius = multiplier * INITIAL_RADIUS

func expand() -> void:
	$Sprite2D.show()
	set_random_pitch()
	$BangSound.play()
	for i in range(radius, expanded_radius):
		freeze_enemies()
		$CollisionShape2D.shape.radius += 1
		update_sprite_scale()
		await get_tree().create_timer(0.01).timeout
	freeze_enemies()
	remove_targets()
	await get_tree().create_timer(0.1).timeout
	for i in range(radius, expanded_radius):
		$CollisionShape2D.shape.radius -= 1
		update_sprite_scale()
		await get_tree().create_timer(0.01).timeout
	$Sprite2D.hide()
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		#body.loseHealth(damage)
		damage_targets.append(body)
	pass # Replace with function body.

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		#body.loseHealth(damage)
		damage_targets.erase(body)
	pass # Replace with function body.

func _on_expand_timer_timeout() -> void:
	expand()
	pass # Replace with function body.

func freeze_enemies() -> void:
	for target in damage_targets:	
		if is_instance_valid(target) and target.health > 0 and target.has_method("freeze"):
			target.freeze(freeze_time)
	
func remove_targets() -> void:
	damage_targets.clear()

func reset_circle() -> void:
	$CollisionShape2D.shape.radius = INITIAL_RADIUS

func set_freeze_time(new_time: float):
	freeze_time = new_time

func set_random_pitch() -> void:
	$BangSound.pitch_scale = randf_range(0.9,1.1)
	pass
