extends Weapon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_name = "test_gun"
	hide_aim_line()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	aim()
	pass

func shoot(mousePos: Vector2) -> void:
	var projectile = plasma_proj.instantiate()
	get_tree().current_scene.add_child(projectile)
	var direction: Vector2 = mousePos - global_position
	projectile.sprite.modulate = Color.GREEN
	projectile.setDirection(direction)
