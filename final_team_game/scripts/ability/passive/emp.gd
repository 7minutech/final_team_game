extends Sprite2D

class_name EMP

const INITIAL_SCALE: Vector2 = Vector2(0.05,0.05)
const INITIAL_FREEZE_TIME: float = 1.0
const INITIAL_SCALE_MULTIPLIER: int = 2
const PICK_UP_SCALE_MULTIPLIER: int = 20
const PICK_UP_FREEZE_TIME: float = 10.0
const INITIAL_CD: float = 3.0

var max_qty: float = 8
var expanded_radius: float
var damage_targets = []
var freeze_time = INITIAL_FREEZE_TIME
var cd: float = INITIAL_CD
var boost_flag = false
var scale_multiplier = INITIAL_SCALE_MULTIPLIER
# Called when the node enters the scene tree for the first time.
func _ready():
	$ExpandTimer.wait_time = cd
	self.hide()

func update_stat(qty:int) -> void:
	if not boost_flag:
		match qty:
			1:
				set_freeze_time(INITIAL_FREEZE_TIME + 1.0)
			2:
				set_scale_multiplier(INITIAL_SCALE_MULTIPLIER + 1.0)
			3:
				set_cd(INITIAL_CD - 0.5)
			4:
				set_scale_multiplier(INITIAL_SCALE_MULTIPLIER + 2.0)
			5:
				set_freeze_time(INITIAL_FREEZE_TIME + 2.0)
			6:
				set_cd(INITIAL_CD - 0.5)
			7:
				set_freeze_time(INITIAL_FREEZE_TIME + 3.0)
			8:
				set_scale_multiplier(INITIAL_SCALE_MULTIPLIER + 4.0)
			_:
				print("Invalid level")

func expand(multiplier: int) -> void:
	self.show()
	set_random_pitch()
	$BangSound.play()
	
	var expanded_scale = INITIAL_SCALE * multiplier
	var current_scale = INITIAL_SCALE
	scale = current_scale
	
	while current_scale.x <= expanded_scale.x:
		current_scale += Vector2(0.01, 0.01)
		scale = current_scale
		freeze_enemies()
		await get_tree().create_timer(0.02).timeout

	freeze_enemies()
	remove_targets()
	await get_tree().create_timer(0.1).timeout

	while current_scale.x >= INITIAL_SCALE.x:
		current_scale -= Vector2(0.01, 0.01)
		scale = current_scale
		freeze_enemies()
		await get_tree().create_timer(0.02).timeout

	self.hide()

func expand_boost(_new_radius) -> void:
	expand(PICK_UP_SCALE_MULTIPLIER)

func _on_expand_timer_timeout() -> void:
	if not boost_flag:
		expand(scale_multiplier)
	pass # Replace with function body.

func freeze_enemies() -> void:
	for target in damage_targets:	
		if is_instance_valid(target) and target.health > 0 and target.has_method("freeze"):
			if not boost_flag:
				target.freeze(freeze_time)
			else:
				target.freeze(PICK_UP_FREEZE_TIME)
	
func remove_targets() -> void:
	damage_targets.clear()

func set_freeze_time(new_time: float):
	freeze_time = new_time

func set_scale_multiplier(new_multiplier: int) -> void:
	scale_multiplier = new_multiplier

func set_random_pitch() -> void:
	$BangSound.pitch_scale = randf_range(0.9,1.1)
	pass

func set_boost(flag: bool) -> void:
	boost_flag = flag

func set_cd(new_cd: float) -> void:
	cd = new_cd

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		damage_targets.append(body)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		damage_targets.erase(body)
	pass # Replace with function body.
