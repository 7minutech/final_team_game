extends Node2D

class_name Weapon

@export var plasma_proj: PackedScene

@export var auto: bool = false
@onready var aim_line: Sprite2D =  get_node_or_null("LineAsset")
var weapon_name: String = "default_gun"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var weapon_name: String = "default_gun"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	aim()
	pass
### Functions to handle shooting logic ###
# Function to aim based on the mouse
func aim() -> Vector2:
	var mousePos: Vector2 = get_global_mouse_position()
	self.look_at(mousePos)
	return mousePos
##F
func shoot(mousePos: Vector2) -> void:
	var projectile = plasma_proj.instantiate()
	get_tree().current_scene.add_child(projectile)
	var direction: Vector2 = mousePos - global_position
	projectile.setDirection(direction)

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
