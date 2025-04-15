extends Area2D

class_name Garlic

var max_qty: float = 6
var radius: float
var damage: int = 20
var damage_targets = []
var TICK_INTERVAL: float = 1.0
var tick_timer: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	radius = $CollisionShape2D.shape.radius
	update_sprite_scale()

func _process(delta: float) -> void:
	tick_timer += delta
	if tick_timer >= TICK_INTERVAL:
		tick_timer = 0
		for target in damage_targets:
			if is_instance_valid(target) and target.has_method("loseHealth"):
				target.loseHealth(damage)

func update_sprite_scale():
	var circle:CircleShape2D = $CollisionShape2D.shape 
	var radius = circle.radius

	#size of sprite
	var tex_size = $Sprite2D.texture.get_size()

	#scale sprite to match circle's diameter
	$Sprite2D.scale = Vector2(radius * 2, radius * 2) / tex_size

func update_stat(qty:float) -> void:
	# if qty is 2 then multiplier is 1.2
	var multiplier: float = 1 + (qty / 10)
	radius *= multiplier
	$CollisionShape2D.shape.radius = radius
	update_sprite_scale()

	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		#body.loseHealth(damage)
		damage_targets.append(body)
	pass # Replace with function body.


func _on_damage_ticker_timeout() -> void:
	for target in damage_targets:	
		if is_instance_valid(target) and target.health > 0:
			target.loseHealth(damage)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		#body.loseHealth(damage)
		damage_targets.erase(body)
	pass # Replace with function body.
