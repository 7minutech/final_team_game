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
			

func give_active_ability(ability_key: String) -> void:
	if not player.abilities.has(ability_key) or not player.abilities[ability_key]:
		var ability_scene: PackedScene = load(AbilityObserver.get_ability_path(ability_key))
		var ability_instance = ability_scene.instantiate()
		player.add_child(ability_instance)
		player.abilities[ability_key] = ability_instance
		player.ability_qty[ability_key] = 1
	else:
		player.ability_qty[ability_key] += 1
	var ability = player.abilities[ability_key]
	if ability.has_method("update_stat"):
		ability.update_stat(player.ability_qty[ability_key])

func set_movement_speed_buff() -> void:
	var multiplier = 1 + (movement_speed_buff * player.ability_qty["movement_speed"])
	var new_speed = (player.INITIAL_SPEED * multiplier)
	player.set_speed(new_speed)

func give_garlics() -> void:
	for i in range(player.garlic_level):
		AbilityObserver.give_active_ability("garlic")

func give_movement_speeds():
	for i in range(player.movement_speed_level):
		AbilityObserver.give_passive_ability("movement_speed")

func give_init_abilities():
	give_garlics()
	give_movement_speeds()
