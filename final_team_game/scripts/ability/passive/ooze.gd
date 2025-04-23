extends Sprite2D

class_name Ooze

const INITIAL_SCALE: Vector2 = Vector2(0.2,0.2)
const INITIAL_DAMAGE: int = 20
const INITAIAL_TICK_INTERVAL: float = 1.0

var max_qty: float = 6
var radius: float
var damage: int = 20
var damage_targets = []
var tick_interval: float = 1.0
var tick_timer: float = 0.0
var ooze_scale = INITIAL_SCALE
var active = true

func _process(delta: float) -> void:
	tick_timer += delta
	if tick_timer >= tick_interval:
		tick_timer = 0
		for target in damage_targets:
			if is_instance_valid(target) and target.has_method("loseHealth"):
				target.loseHealth(damage)

func update_stat(qty: int) -> void:
	match qty:
		1:
			set_damage(INITIAL_DAMAGE + 5)
		2:
			set_ooze_scale(INITIAL_SCALE * 1.25)
		3:
			set_damage_cd(INITAIAL_TICK_INTERVAL - 0.25)
		4:
			set_ooze_scale(INITIAL_SCALE * 1.50)
		5:
			set_damage(INITIAL_DAMAGE + 10)
		6:
			set_damage_cd(INITAIAL_TICK_INTERVAL - 0.5)
		7:
			set_damage(INITIAL_DAMAGE + 15)
		8:
			set_ooze_scale(INITIAL_SCALE * 1.75)
		9:
			set_damage(INITIAL_DAMAGE + 20)
		_:
			print("Invalid level")

func _on_damage_ticker_timeout() -> void:
	for target in damage_targets:	
		if is_instance_valid(target) and target.health > 0:
			target.loseHealth(damage)

func set_damage_cd(new_time: float) -> void:
	tick_interval = new_time

func set_damage(new_damage: int) -> void:
	damage = new_damage

func set_ooze_scale(new_scale: Vector2) -> void:
	scale = new_scale


func _on_ooze_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not damage_targets.has(body):
		if body != null and body.is_inside_tree() and not body.just_spawned:
			body.loseHealth(damage)
		damage_targets.append(body)
	pass # Replace with function body.


func _on_ooze_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		#body.loseHealth(damage)
		damage_targets.erase(body)
	pass # Replace with function body.
