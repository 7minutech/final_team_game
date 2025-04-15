extends Node


var ability_path:Dictionary = {
	"garlic": "res://scenes/ability/passive/garlic.tscn"
}
var movement_speed_buff: float = 0.05
var player: Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_ability_path(key):
	return ability_path[key]

func give_passive_ability(ability_key: String) -> void:
	if not player.abilities.has(ability_key) or not player.abilities[ability_key]:
		player.ability_qty[ability_key] = 1
	else:
		player.ability_qty[ability_key] += 1
	player.abilities[ability_key] = "passive"
	give_passive_boost(ability_key)

func give_passive_boost(ability_name: String):
	match ability_name:
		"movement_speed":
			set_movement_speed_buff()
			

func set_movement_speed_buff() -> void:
	var multiplier = 1 + (movement_speed_buff * player.ability_qty["movement_speed"])
	var new_speed = (player.INITIAL_SPEED * multiplier)
	player.set_speed(new_speed)
