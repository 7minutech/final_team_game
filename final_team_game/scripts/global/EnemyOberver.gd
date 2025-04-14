extends Node
const INITIAL_PROJECTILE_SPEED: int = 5
const INITIAL_DAMAGE: int = 20
const INITIAL_HEALTH: int = 0
var entity_damage_dict: Dictionary = {
	"robot_damage": 0,
 	"blue_drone_damage": 0,
	"robot_boss_damage": 0,
	"alien_damage": 0,
	"red_drone_damage": 0,
	"turret_damage": 0,
	"robot_damage_boss": 0
	}
var entity_health_dict: Dictionary = {
	"robot_health": INITIAL_HEALTH,
 	"blue_drone_health": INITIAL_HEALTH,
	"robot_boss_health": INITIAL_HEALTH,
	"alien_health": INITIAL_HEALTH,
	"red_drone_health": INITIAL_HEALTH,
	"turret_health": INITIAL_HEALTH, 
	"robot_health_boss": INITIAL_HEALTH
	}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var default_health_scale: float = ((TimeObserver.total_time / 60.0) * 10)
	for key in entity_health_dict.keys():
		entity_health_dict[key] = default_health_scale
	

func set_health_value(key: String, value):
	entity_health_dict[key] = value

func set_damage_value(key: String, value):
	entity_damage_dict[key] = value
