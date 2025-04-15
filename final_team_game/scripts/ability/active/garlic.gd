extends Area2D

class_name Garlic

var max_qty: int = 6
var radius: int
# Called when the node enters the scene tree for the first time.
func _ready():
	radius = $CollisionShape2D.shape.radius
	update_sprite_scale()

func update_sprite_scale():
	var circle:CircleShape2D = $CollisionShape2D.shape 
	var radius = circle.radius

	#size of sprite
	var tex_size = $Sprite2D.texture.get_size()

	#scale sprite to match circle's diameter
	$Sprite2D.scale = Vector2(radius * 2, radius * 2) / tex_size

func update_stat(qty:int) -> void:
	# if qty is 2 then multiplier is 1.2
	var multiplier: float = 1 + (qty / 10) * 2
	radius *= multiplier
	$CollisionShape2D.shape.radius = radius
	update_sprite_scale()
	
