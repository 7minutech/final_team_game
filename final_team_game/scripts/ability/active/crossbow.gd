extends Weapon

const INITIAL_REFLECTIONS: int = 2
const INITIAL_DMG: int = 5
const INITIAL_SPEED: float = 2

## Variables
var reflections = INITIAL_REFLECTIONS
var remaining_reflections = INITIAL_REFLECTIONS
var disk_speed: float = 2
var disk_dmg: int = INITIAL_DMG
var disk_projectile: PackedScene = load("res://scenes/hero/DiskProjectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_name = "crossbow"
	$ShootCd.start()
	set_shoot_cd(base_shoot_cd)
	set_weapon_dmg(disk_dmg)
	set_projectile_speed(disk_speed)
	hide_aim_line()
	var target_area = $TargetArea 
	target_area.area_entered.connect(_on_target_area_area_entered)
	target_area.area_exited.connect(_on_target_area_area_exited)
	var auto_cd = $AutoShootCd
	auto_cd.timeout.connect(_on_auto_shoot_cd_timeout)
	set_auto_shoot_cd(1)
	var shoot_cd: Timer = $ShootCd
	shoot_cd.timeout.connect(_on_shoot_cd_timeout)
	set_shoot_cd(base_shoot_cd)
	pass # Replace with function body.

func shoot(mousePos: Vector2) -> void:
	var proj: DiskProjectile = disk_projectile.instantiate()
	proj.setDamage(disk_dmg)
	proj.setSpeed(disk_speed)
	proj.set_reflection(reflections)
	get_tree().current_scene.add_child(proj)
	var direction: Vector2 = mousePos - global_position
	proj.setDirection(direction)

func auto_shoot() -> void:
	if auto and not targets.is_empty():
		var proj = disk_projectile.instantiate()
		proj.setDamage(disk_dmg)
		proj.setSpeed(disk_speed)
		proj.set_reflection(reflections)
		get_tree().current_scene.add_child(proj)
		if targets[0] != null:
			var enemy_position: Vector2 = targets[0].global_position
			proj.global_position = self.global_position
			var direction: Vector2 = enemy_position - self.global_position
			proj.look_at(enemy_position) 
			proj.setDirection(direction)
	pass

func update_stat(qty: int) -> void:
	match qty:
		1:
			set_reflections(INITIAL_REFLECTIONS + 1)
		2:
			set_weapon_dmg(INITIAL_DMG + 5)
		3:
			set_projectile_speed(INITIAL_SPEED + 1)
		4:
			set_reflections(INITIAL_REFLECTIONS + 2)
		5:
			set_shoot_cd(base_shoot_cd - 0.25)
		6:
			set_weapon_dmg(INITIAL_DMG + 10)
		7:
			set_reflections(INITIAL_REFLECTIONS + 3)
		_:
			print("Invalid level")

	print("Updated crossbow to level: " + str(qty))

func set_weapon_dmg(dmg: int) -> void:
	disk_dmg = dmg

func set_projectile_speed(speed: int) -> void:
	disk_speed = speed

func set_reflections(num_reflections: int) -> void:
	reflections = num_reflections
