extends Sprite2D

class_name Garlic

const INITIAL_SCALE: Vector2 = Vector2(0.2,0.2)

var max_qty: float = 6
var radius: float
var damage: int = 20
var damage_targets = []
var TICK_INTERVAL: float = 1.0
var tick_timer: float = 0.0
var garlic_scale = INITIAL_SCALE
var active = true

func _process(delta: float) -> void:
	tick_timer += delta
	if tick_timer >= TICK_INTERVAL:
		tick_timer = 0
		for target in damage_targets:
			if is_instance_valid(target) and target.has_method("loseHealth"):
				target.loseHealth(damage)

func update_stat(qty:float) -> void:
	# if qty is 2 then multiplier is 1.2
	var multiplier: float = 1 + (qty / 10)
	scale = INITIAL_SCALE * multiplier

func _on_damage_ticker_timeout() -> void:
	for target in damage_targets:	
		if is_instance_valid(target) and target.health > 0:
			target.loseHealth(damage)

func _on_garlic_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not damage_targets.has(body):
		if body != null and body.is_inside_tree() and not body.just_spawned:
			body.loseHealth(damage)
		damage_targets.append(body)
	pass # Replace with function body.


func _on_garlic_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		#body.loseHealth(damage)
		damage_targets.erase(body)
	pass # Replace with function body.
