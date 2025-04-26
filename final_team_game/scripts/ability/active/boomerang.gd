extends Weapon

var maxRicochets: int = 0
var maxProj: int = 0
var numProj: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_projectile_scene(preload("res://scenes/ability/active/boomerang_projectile.tscn"))
	base_weapon_dmg = 25
	base_project_speed = 3
	$ShootCd.start()
	set_shoot_cd(.5)
	set_weapon_dmg(base_weapon_dmg)
	set_projectile_speed(base_project_speed)
	weapon_name = "boomerang"
	hide_aim_line()
	var target_area = $TargetArea 
	#target_area.body_entered.connect(_on_target_area_body_entered)
	#target_area.body_exited.connect(_on_target_area_body_exited)
	target_area.area_entered.connect(_on_target_area_area_entered)
	target_area.area_exited.connect(_on_target_area_area_exited)
	var auto_cd = $AutoShootCd
	auto_cd.timeout.connect(_on_auto_shoot_cd_timeout)
	set_auto_shoot_cd(.5)
	var shoot_cd: Timer = $ShootCd
	shoot_cd.timeout.connect(_on_shoot_cd_timeout)
	set_shoot_cd(base_shoot_cd)
	pass # Replace with function body.

## Functions for shooting
func shoot(mousePos: Vector2) -> void:
	if numProj < maxProj:
		var proj = projectile.instantiate()
		proj.setParent(self)
		proj.setDamage(weapon_dmg)
		proj.setSpeed(projectile_speed)
		get_tree().current_scene.add_child(proj)
		var direction: Vector2 = mousePos - global_position
		proj.setDirection(direction)
##
func auto_shoot() -> void:
	if auto and not targets.is_empty() and numProj < maxProj:
		var proj = projectile.instantiate()
		proj.setParent(self)
		proj.setDamage(weapon_dmg)
		proj.setSpeed(projectile_speed)
		get_tree().current_scene.add_child(proj)
		if targets[0] != null:
			var enemy_position: Vector2 = targets[0].global_position
			proj.global_position = self.global_position
			var direction: Vector2 = enemy_position - self.global_position
			proj.look_at(enemy_position) 
			proj.setDirection(direction)

### Functions for stats ###
func set_max_proj(qty: int) -> void:
	maxProj = qty
func set_max_ricochets(qty: int) -> void:
	maxRicochets = qty
	

func update_stat(qty: int) -> void:
	match qty:
		1:
			set_max_proj(1)
		2:
			set_projectile_speed(base_project_speed + 4)
		3:
			set_max_ricochets(2)
		4:
			set_max_proj(maxProj + 1)
		5:
			set_max_ricochets(4)
		_:
			print("Invalid level")

	print("Updated boomerang to level: " + str(qty))
