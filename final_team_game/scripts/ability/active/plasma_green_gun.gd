extends Weapon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_shoot_cd(base_shoot_cd)
	weapon_name = "test_gun"
	hide_aim_line()
	var target_area = $TargetArea 
	var shoot_cd: Timer = $ShootCd
	shoot_cd.timeout.connect(_on_shoot_cd_timeout)
	target_area.body_entered.connect(_on_target_area_body_entered)
	target_area.body_exited.connect(_on_target_area_body_exited)
	target_area.area_entered.connect(_on_target_area_area_entered)
	target_area.area_exited.connect(_on_target_area_area_exited)
	var auto_cd = $AutoShootCd
	auto_cd.timeout.connect(_on_auto_shoot_cd_timeout)
	set_auto_shoot_cd(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func shoot(mousePos: Vector2) -> void:
	var projectile = plasma_proj.instantiate()
	get_tree().current_scene.add_child(projectile)
	var direction: Vector2 = mousePos - global_position
	projectile.sprite.modulate = Color.GREEN
	projectile.setDirection(direction)

func auto_shoot() -> void:
	if auto and not targets.is_empty():
		var projectile = plasma_proj.instantiate()
		get_tree().current_scene.add_child(projectile)
		if targets[0] != null:
			var enemy_position: Vector2 = targets[0].global_position
			projectile.global_position = self.global_position
			var direction: Vector2 = enemy_position - self.global_position
			projectile.sprite.modulate = Color.GREEN
			projectile.look_at(enemy_position) 
			projectile.setDirection(direction)
	pass
