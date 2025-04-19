extends Node2D

class_name Weapon

const PLASMA_PROJ = preload("res://scenes/hero/PlasmaProjectile.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
### Functions to handle shooting logic ###
# Function to aim based on the mouse
func aim() -> Vector2:
	var mousePos: Vector2 = get_global_mouse_position()
	return mousePos
##F
func shoot(mousePos: Vector2) -> void:
	var projectile = PLASMA_PROJ.instantiate()
	get_tree().current_scene.add_child(projectile)
	var direction: Vector2 = mousePos - global_position
	projectile.setDirection(direction)

func update_stat(qty: int) -> void:
	print("updated default gun to level: " + str(qty))
