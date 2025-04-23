extends Sprite2D

const INTIAL_BEAM_SCALE: Vector2 = Vector2(1.162,1.123)
const INTIAL_ORBIT_SPEED: float = 0.5
const INITIAL_BEAM_DAMAGE: int = 20

var radius: int = 125
var angle: float = 0.0
var orbit_speed: float = INTIAL_ORBIT_SPEED
var damage: int = INITIAL_BEAM_DAMAGE
var beam_scale: Vector2 = INTIAL_BEAM_SCALE
var enemies_in_beam: Array = []
var damage_timer := 1.0 
var time_accumulator := 0.0

func _ready() -> void:
	$Beam.scale = INTIAL_BEAM_SCALE
	#var player = PlayerObserver.player
	#global_position = player.global_position + offset_from_player
	pass

func _process(delta):
	angle += orbit_speed * delta
	if PlayerObserver.player:
		var center = PlayerObserver.player.global_position
		
		#rotating relative to center(Player)
		global_position = center + Vector2(radius, 0).rotated(angle)
		
		# Point away from the center 
		# don't need to rotate b/c it's already looking away
		look_at(center)
	time_accumulator += delta
	if time_accumulator >= damage_timer:
		# Use a copy to avoid modifying the array 
		for enemy in enemies_in_beam.duplicate():
			if enemy == null or not enemy.is_inside_tree():
				enemies_in_beam.erase(enemy)
			else:
				enemy.loseHealth(damage)
		time_accumulator = 0.0

func update_stat(qty: int) -> void:
	match qty:
		1:
			set_damage(INITIAL_BEAM_DAMAGE + 5)
		2:
			set_orbit_speed(INTIAL_ORBIT_SPEED + 0.5)
		3:
			set_beam_scale(INTIAL_BEAM_SCALE * 1.25)
		4:
			set_orbit_speed(INTIAL_ORBIT_SPEED + 1.0)
		5:
			set_damage(INITIAL_BEAM_DAMAGE + 10)
		6:
			set_beam_scale(INTIAL_BEAM_SCALE * 1.5)
		7:
			set_damage(INITIAL_BEAM_DAMAGE + 15)
		8:
			set_orbit_speed(INTIAL_ORBIT_SPEED + 1.5)
		9:
			set_damage(INITIAL_BEAM_DAMAGE + 20)
		_:
			print("Invalid level")


func _on_beam_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not enemies_in_beam.has(body):
		if body != null and body.is_inside_tree():
			body.loseHealth(damage)
		enemies_in_beam.append(body)
	pass # Replace with function body.


func _on_beam_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_beam.erase(body)
	pass # Replace with function body.

func set_damage(dmg: int) -> void:
	damage = dmg

func set_orbit_speed(new_speed: float) -> void:
	orbit_speed = new_speed

func set_beam_scale(new_scale: Vector2) -> void:
	beam_scale = new_scale
