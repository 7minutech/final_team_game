extends Weapon

### Constants ###

### Variables ###
var canShoot: bool = true
var max_ricochets: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.proj =  preload("res://scenes/ability/active/boomerang_projectile.tscn")
	self.projectile_speed = 10
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if canShoot:
		shoot(aim())

func shoot(mousePos: Vector2) -> void:
	canShoot = false
	var projectile: RigidBody2D = proj.instantiate()
	projectile.setSpeed(projectile_speed)
	projectile.setMaxRicochets(max_ricochets)
	projectile.setEndPoint(mousePos)
	get_tree().current_scene.add_child(projectile)
	var direction: Vector2 = mousePos - global_position
	projectile.setDirection(direction)

func updateStats() -> void:
	pass
