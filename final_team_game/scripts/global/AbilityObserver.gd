extends Node

### Constants ###
const ABILITY_SCENE_PATH:Dictionary = {
	# Damaging abilities
	"garlic": "res://scenes/ability/passive/garlic.tscn"
	
	# Non-damaging abilities
	
}
const ABILITY_ASSET_PATH: Dictionary = {
	# Damaging abilities
	
	# Non-damaging abilitites
	"heart": "res://assets/ability_icons/Heart.png",
	"heartWithGreenPlus": "res://assets/ability_icons/HeartWithGreenPlus.png",
	"magnet": "res://assets/ability_icons/Magnet.png",
	"shield": "res://assets/ability_icons/Shield.png"
}
const ABILITY_DESCRIPTIONS: Dictionary = {
	# Damaging abilities
	"garlic": "Adds a damaging area around the player",
	
	# Non-damaging abilities
	"heart": "Provides a boost to max health",
	"heartWithGreenPlus": "Provides health regen over time",
	"magnet": "Increases the radius that the player can pick up items",
	"shield": "Provides temporary invulnerability after taking damage"
}


### Variables ###
var movement_speed_buff: float = 0.05
var max_health_buff: float = 0.05
var health_regen_buff: float = 0.2
var pick_up_buff: float = 0.2
var shield_duration_buff: float = 0.2
var shield_cd_buff: float = 0.3
var player: Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func get_ability_path(key):
	return ABILITY_SCENE_PATH[key]

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
		"max_health":
			set_max_health_buff()
		"health_regen":
			set_health_regen_buff()
		"pick_up_range":
			set_pick_up_buff()
		"shield":
			set_shield_duration_buff()
			set_shield_cd_buff()
			

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

func set_max_health_buff() -> void:
	var multiplier = 1 + (max_health_buff * player.ability_qty["max_health"])
	var new_health = (player.INITIAL_MAX_XP * multiplier)
	player.set_max_health(new_health)

func set_health_regen_buff() -> void:
	var flat_bonus = (health_regen_buff * player.ability_qty["health_regen"])
	var new_health_regen = (player.INITIAL_HEALTH_REGEN + flat_bonus)
	player.set_health_regen(new_health_regen)

func set_pick_up_buff() -> void:
	var multiplier = 1 + (pick_up_buff * player.ability_qty["pick_up_range"])
	var new_range = (player.INITIAL_PICK_UP_RANGE * multiplier)
	player.set_pick_up_range(new_range)

func set_shield_duration_buff() -> void:
	var new_duration = (player.shield_duration + shield_duration_buff)
	player.set_shield_duration(new_duration)

func set_shield_cd_buff() -> void:
	var new_cd = (player.shield_cd - shield_duration_buff)
	player.set_shield_cd(new_cd)

func give_garlics() -> void:
	for i in range(player.garlic_level):
		AbilityObserver.give_active_ability("garlic")

func give_movement_speeds():
	for i in range(player.movement_speed_level):
		AbilityObserver.give_passive_ability("movement_speed")

func give_max_healths():
	for i in range(player.max_health_level):
		AbilityObserver.give_passive_ability("max_health")

func give_health_regens():
	for i in range(player.health_regen_level):
		AbilityObserver.give_passive_ability("health_regen")

func give_pick_up_ranges():
	for i in range(player.pick_up_range_level):
		AbilityObserver.give_passive_ability("pick_up_range")

func give_shield_durations():
	for i in range(player.shield_level):
		AbilityObserver.give_passive_ability("shield")

func give_shield_cds():
	for i in range(player.shield_level):
		AbilityObserver.give_passive_ability("shield")

func give_init_abilities():
	give_garlics()
	give_movement_speeds()
	give_max_healths()
	give_health_regens()
	give_pick_up_ranges()
	give_shield_cds()
	give_shield_durations()
