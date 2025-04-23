extends Sprite2D

const INTIAL_BEAM_SCALE: Vector2 = Vector2(1.162,1.123)

var radius: int = 125
var angle: float = 0.0
var speed: float = 0.5
var dmg: int = 20 
var beam_scale: Vector2 = INTIAL_BEAM_SCALE

func _ready() -> void:
	$Beam.scale = INTIAL_BEAM_SCALE
	#var player = PlayerObserver.player
	#global_position = player.global_position + offset_from_player
	pass

func _process(delta):
	angle += speed * delta
	if PlayerObserver.player:
		var center = PlayerObserver.player.global_position
		
		#rotating relative to center(Player)
		global_position = center + Vector2(radius, 0).rotated(angle)
		
		# Point away from the center 
		# don't need to rotate b/c it's already looking away
		look_at(center)

func update_stat(qty:float) -> void:
	# if qty is 2 then multiplier is 1.2
	var multiplier: float = 1 + (qty / 10)
	var new_scale: Vector2 = INTIAL_BEAM_SCALE * multiplier
	beam_scale = new_scale
	$Beam.scale = beam_scale
