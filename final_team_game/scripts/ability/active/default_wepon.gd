extends Node2D

class_name Weapon

@export var projectile: PackedScene
var targets = []
@export var auto: bool = true
@onready var aim_line: Sprite2D =  get_node_or_null("LineAsset")
var weapon_name: String = "default_gun"
var auto_shoot_cd: float = 1
var weapon_dmg: int
var projectile_speed: int
var base_weapon_dmg: int = 20
var base_project_speed: int = 8
var base_shoot_cd: float = 1.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_shoot_cd(base_shoot_cd)
	set_projectile_speed(base_project_speed)
	set_weapon_dmg(base_weapon_dmg)
	var target_area = $TargetArea 
	target_area.body_entered.connect(_on_target_area_body_entered)
	target_area.body_exited.connect(_on_target_area_body_exited)
	target_area.area_entered.connect(_on_target_area_area_entered)
	target_area.area_exited.connect(_on_target_area_area_exited)
	
	var auto_cd = $AutoShootCd
	auto_cd.timeout.connect(_on_auto_shoot_cd_timeout)
	var shoot_cd: = $ShootCd
	shoot_cd.timeout.connect(_on_shoot_cd_timeout)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	clear_invalid_targets()
	aim()
	pass
### Functions to handle shooting logic ###
# Function to aim based on the mouse
func aim() -> Vector2:
	var mousePos: Vector2 = get_global_mouse_position()
	self.look_at(mousePos)
	return mousePos
##
func shoot(mousePos: Vector2) -> void:
	var proj = projectile.instantiate()
	proj.setDamage(weapon_dmg)
	proj.setSpeed(projectile_speed)
	get_tree().current_scene.add_child(proj)
	var direction: Vector2 = mousePos - global_position
	proj.setDirection(direction)

func update_stat(qty: int) -> void:
	print("updated default gun to level: " + str(qty))

func set_auto(flag: bool) -> void:
	auto = flag

func hide_aim_line() -> void:	
	if aim_line:
		aim_line.hide()

func show_aim_line() -> void:
	if aim_line:
		aim_line.show()

func auto_shoot() -> void:
	if auto and not targets.is_empty():
		var proj = projectile.instantiate()
		get_tree().current_scene.add_child(proj)
		if targets[0] != null:
			var enemy_position: Vector2 = targets[0].global_position
			proj.global_position = self.global_position
			var direction: Vector2 = enemy_position - self.global_position
			proj.look_at(enemy_position) 
			proj.setDirection(direction)
	pass

func set_target_radius(new_radius: int) -> void: 
	var area_shape = get_node_or_null("TargetArea/CollisionShape2D")
	if area_shape:
		$TargetArea/CollisionShape2D.shape.radius = new_radius


func _on_target_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.push_front(body)
	pass # Replace with function body.


func _on_target_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		targets.erase(body)
	pass # Replace with function body.

func clear_invalid_targets() -> void:
	for target in targets:
		if not is_instance_valid(target):
			targets.erase(target)
		elif target.health <= 0:
			targets.erase(target)

func _on_target_area_area_entered(area: Area2D) -> void:
	pass

func _on_target_area_area_exited(area: Area2D) -> void:
	pass



func display_radius() -> void:
	print($TargetArea/CollisionShape2D.shape.radius)


func set_auto_shoot_cd(new_time: float) -> void:
	$AutoShootCd.wait_time = new_time
	
func set_weapon_dmg(dmg: int) -> void:
	weapon_dmg = dmg

func set_projectile_speed(speed: int) -> void:
	projectile_speed = speed

func set_shoot_cd(new_time: float) -> void:
	$ShootCd.wait_time = new_time

func _on_auto_shoot_cd_timeout() -> void:
	auto_shoot()
	pass # Replace with function body.

func set_projectile_scene(proj_scene: PackedScene) -> void:
	projectile = proj_scene

func _on_shoot_cd_timeout() -> void:
	if not auto:
		self.shoot(aim())
	pass # Replace with function body.
