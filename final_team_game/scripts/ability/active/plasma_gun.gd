extends Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapon_name = "plasma_gun"
	hide_aim_line()
	var target_area = $TargetArea 
	target_area.body_entered.connect(_on_target_area_body_entered)
	target_area.body_exited.connect(_on_target_area_body_exited)
	target_area.area_entered.connect(_on_target_area_area_entered)
	target_area.area_exited.connect(_on_target_area_area_exited)
	var auto_cd = $AutoShootCd
	auto_cd.timeout.connect(_on_auto_shoot_cd_timeout)
	set_auto_shoot_cd(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
