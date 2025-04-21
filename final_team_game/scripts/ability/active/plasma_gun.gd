extends Weapon


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ShootCd.start()
	set_shoot_cd(base_shoot_cd)
	set_weapon_dmg(base_weapon_dmg)
	set_projectile_speed(base_project_speed)
	weapon_name = "plasma_gun"
	hide_aim_line()
	var target_area = $TargetArea 
	#target_area.body_entered.connect(_on_target_area_body_entered)
	#target_area.body_exited.connect(_on_target_area_body_exited)
	target_area.area_entered.connect(_on_target_area_area_entered)
	target_area.area_exited.connect(_on_target_area_area_exited)
	var auto_cd = $AutoShootCd
	auto_cd.timeout.connect(_on_auto_shoot_cd_timeout)
	set_auto_shoot_cd(1)
	var shoot_cd: Timer = $ShootCd
	shoot_cd.timeout.connect(_on_shoot_cd_timeout)
	set_shoot_cd(base_shoot_cd)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_stat(qty: int) -> void:
	match qty:
		1:
			set_weapon_dmg(base_weapon_dmg + 5)
		2:
			set_projectile_speed(base_project_speed + 5)
		3:
			set_shoot_cd(base_shoot_cd - 0.25)
		4:
			set_projectile_speed(base_project_speed + 10)
		5:
			set_weapon_dmg(base_weapon_dmg + 15)
		6:
			set_shoot_cd(base_shoot_cd - 0.50)
		7:
			set_weapon_dmg(base_weapon_dmg + 20)
		8:
			set_projectile_speed(base_project_speed + 20)
		9:
			set_weapon_dmg(base_weapon_dmg + 25)
		_:
			print("Invalid level")

	print("Updated default gun to level: " + str(qty))
