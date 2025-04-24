extends Sprite2D
class_name OrbitalBeam

const INTIAL_BEAM_SCALE: Vector2 = Vector2(1.162, 1.123)
const INTIAL_ORBIT_SPEED: float = 0.5
const INITIAL_BEAM_DAMAGE: int = 20
const orbital_beam_scene = preload("res://scenes/ability/passive/orbital_beam.tscn")
const MAX_BEAM_COUNT: int = 4  

var radius: int = 125
var angle: float = 0.0
var orbit_speed: float = INTIAL_ORBIT_SPEED
var damage: int = INITIAL_BEAM_DAMAGE
var beam_scale: Vector2 = INTIAL_BEAM_SCALE
var enemies_in_beam: Array = []
var damage_timer := 1.0 
var time_accumulator := 0.0
var new_orbital_beams: Array = []
var angle_offset: float = 0.0

func _ready() -> void:
	$Beam.scale = beam_scale  #
	pass

func _process(delta):
	angle += orbit_speed * delta
	if PlayerObserver.player:
		var center = PlayerObserver.player.global_position
		var current_angle = angle + angle_offset
		# Rotating relative to center (Player)
		global_position = center + Vector2(radius, 0).rotated(current_angle)  # Use the current_angle
		
		# Point away from the center
		look_at(center)
		
	time_accumulator += delta
	if time_accumulator >= damage_timer:
		# Use a copy to avoid modifying the array while iterating
		for enemy in enemies_in_beam.duplicate():
			if enemy == null or not enemy.is_inside_tree():
				enemies_in_beam.erase(enemy)
			else:
				enemy.loseHealth(damage)
		time_accumulator = 0.0

func update_stat(qty: int) -> void:
	print("Updating orbital beam stats for qty:", qty)
	
	# Reset to initial values
	damage = INITIAL_BEAM_DAMAGE
	orbit_speed = INTIAL_ORBIT_SPEED
	beam_scale = INTIAL_BEAM_SCALE
	
	# Apply all upgrades up to current level
	for level in range(1, qty + 1):
		match level:
			1:
				damage += 5
				print("Level 1: damage now", damage)
			2:
				orbit_speed += 0.5
			3:
				add_orbital_beam()
			4:
				orbit_speed += 0.5 
			5:
				add_orbital_beam()
			6:
				beam_scale = INTIAL_BEAM_SCALE * 1.5
				$Beam.scale = beam_scale 
			7:
				add_orbital_beam()
			8:
				orbit_speed += 0.5  
			9:
				damage += 15  
	
	# Update all beam properties
	update_all_beams()

func _on_beam_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and not enemies_in_beam.has(body):
		if body != null and body.is_inside_tree():
			body.loseHealth(damage)
		enemies_in_beam.append(body)

func _on_beam_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		enemies_in_beam.erase(body)

func add_orbital_beam() -> void:
	var current_beam_count = 1 + new_orbital_beams.size()  # Original + new beams
	
	if current_beam_count >= MAX_BEAM_COUNT:
		return
	
	var player = PlayerObserver.player
	if player:
		var orbital_beam_instance = orbital_beam_scene.instantiate()
		new_orbital_beams.append(orbital_beam_instance)
		player.add_child(orbital_beam_instance)
		
		# Initialize the new beam with current properties
		orbital_beam_instance.damage = damage
		orbital_beam_instance.orbit_speed = orbit_speed
		orbital_beam_instance.beam_scale = beam_scale
				
		# Update angle offsets for all beams
		update_all_beams()

func update_all_beams() -> void:
	# Count including the original beam
	var all_beams = [self] + new_orbital_beams
	var count = all_beams.size()
	
	# Distribute beams evenly in a circle
	for i in range(count):
		var beam = all_beams[i]
		var offset_angle = TAU * i / count
		
		# Update all properties
		beam.angle_offset = offset_angle
		beam.damage = damage
		beam.beam_scale = beam_scale
		beam.orbit_speed = orbit_speed
		
		# Update visual scale
		if beam.has_node("Beam"):
			beam.get_node("Beam").scale = beam_scale
