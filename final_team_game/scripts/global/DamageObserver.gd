extends Node
const INITIAL_PROJECTILE_SPEED: int = 5
const INITIAL_DAMAGE: int = 20
var weapon_damage_dict: Dictionary = {"plasma_projectile_damage": INITIAL_DAMAGE,
 									"plasma_projectile_speed" : INITIAL_PROJECTILE_SPEED}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func set_value(key: String, value):
	weapon_damage_dict[key] = value
