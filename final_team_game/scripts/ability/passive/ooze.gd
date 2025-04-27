extends Sprite2D

class_name Ooze

const INITIAL_SCALE: Vector2 = Vector2(0.25,0.25)
const INITIAL_DAMAGE: int = 5
const INITAIAL_TICK_INTERVAL: float = 2.5
const INITIAL_QUEUE_TIMER: float = 2.5
const INITIAL_PULSE_LIMIT: int = 2
const INITIAL_DROP_CD: float = 3.0

var max_qty: float = 9
var radius: float
var damage: int = INITIAL_DAMAGE
var damage_targets = []
var tick_interval: float = INITAIAL_TICK_INTERVAL
var tick_timer: float = 0.0
var ooze_scale = INITIAL_SCALE
var active = true
var queue_timer_time: float = INITIAL_QUEUE_TIMER
var pulses: int = 0
var pulse_limit: int = INITIAL_PULSE_LIMIT #off by 1 so 3 pulses will happen
var drop_cd: float = INITIAL_DROP_CD
	
func _ready() -> void:
	$AnimationPlayer.play("glow")
	global_position = PlayerObserver.player.global_position	

func _process(delta: float) -> void:
	if tick_timer == 0:
		print("Current damage value:", damage)
	tick_timer += delta
	if tick_timer >= tick_interval:
		tick_timer = 0
		for target in damage_targets:
			if is_instance_valid(target) and target.has_method("loseHealth"):
				target.loseHealth(damage)


func update_stat(qty: int) -> void:
	for level: int in range(1, qty + 1):
		match level:
			1:
				set_damage(INITIAL_DAMAGE + 5)
			2:
				set_ooze_scale(INITIAL_SCALE * 1.25)
			3:
				set_damage_cd(INITAIAL_TICK_INTERVAL - 0.25)
			4:
				set_ooze_pulse_limit(INITIAL_PULSE_LIMIT * 2)
			5:
				set_drop_cd(INITIAL_DROP_CD - 1.0)
			6:
				set_damage_cd(INITAIAL_TICK_INTERVAL - 0.5)
			7:
				set_ooze_pulse_limit(INITIAL_PULSE_LIMIT * 3)
			8:
				set_ooze_scale(INITIAL_SCALE * 1.75)
			9:
				set_damage(INITIAL_DAMAGE + 10)
			_:
				print("Invalid level")

func _on_damage_ticker_timeout() -> void:
	for target in damage_targets:	
		if is_instance_valid(target) and target.health > 0:
			target.loseHealth(damage)

func set_damage_cd(new_time: float) -> void:
	tick_interval = new_time

func set_damage(new_damage: int) -> void:
	print("Setting damage from", damage, "to", new_damage)
	damage = new_damage
	print("After setting, damage is now:", damage)

func set_ooze_scale(new_scale: Vector2) -> void:
	scale = new_scale

func set_ooze_pulse_limit(new_pulse_limit: int) -> void:
	pulse_limit = new_pulse_limit

func set_drop_cd(new_drop_cd: float) -> void:
	drop_cd = new_drop_cd

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

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "glow":
		pulses += 1
		$AnimationPlayer.play("glow")
	if pulses >= pulse_limit:
		$AnimationPlayer.play("fade")
	if anim_name == "fade":
		queue_free()
	pass # Replace with function body.
