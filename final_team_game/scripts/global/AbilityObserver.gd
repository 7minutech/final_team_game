extends Node

### Constants ###
# radiation level 1 would be ABILITY_UPGRADE_DESC["radiation"][1]
const ABILITY_UPGRADE_DESC: Dictionary = {
	"radiation" : {
		1: "Increase damage by 5", 
		2: "Increase radiation area of effect by 25%", 
		3: "Decrease damage cooldown to 0.75s",  
		4: "Increase radiation area of effect by 50%",  
		5: "Decrease damage cooldown to 0.5s", 
		6: "Increase radiation area of effect by 75%", 
		7: "Increase damage by 10",  
		8: "Increase radiation area of effect by 100%", 
		9: "Increase damage by 15"  
	},
	"orbital_beam": {
		1: "Increase beam damage by 5",
		2: "Increase orbit speed by 0.5",
		3: "Add an additional orbital beam",
		4: "Increase orbit speed by 0.5",
		5: "Add an additional orbital beam",
		6: "Increase beam scale by 50%",
		7: "Add an additional orbital beam",
		8: "Increase orbit speed by 0.5",
		9: "Increase beam damage by 15"
	},
	"plasma_gun": {
		1: "Increase weapon damage by 5",
		2: "Double projectile speed",
		3: "Reduce shooting cooldown by 0.25s",
		4: "Triple projectile speed",
		5: "Increase weapon damage by 15",
		6: "Reduce shooting cooldown by 0.5s",
		7: "Increase weapon damage by 20",
		8: "Quadruple projectile speed",
		9: "Increase weapon damage by 25"
	},
	"shield": {
		1: "Increase shield duration by 0.2s",
		2: "Reduce shield cooldown by 0.3s",
		3: "Increase shield duration by 0.2s",
		4: "Reduce shield cooldown by 0.3s",
		5: "Increase shield duration by 0.2s"
	},
	"health_regen": {
		1: "Increase health regeneration by 0.2 HP/s",
		2: "Increase health regeneration by 0.2 HP/s",
		3: "Increase health regeneration by 0.2 HP/s",
		4: "Increase health regeneration by 0.2 HP/s",
		5: "Increase health regeneration by 0.2 HP/s"
	},
	"max_health": {
		1: "Increase max health by 5%",
		2: "Increase max health by 5%",
		3: "Increase max health by 5%",
		4: "Increase max health by 5%",
		5: "Increase max health by 5%",
		6: "Increase max health by 5%",
		7: "Increase max health by 5%",
		8: "Increase max health by 5%",
		9: "Increase max health by 5%"
	},
	"movement_speed": {
		1: "Increase movement speed by 5%",
		2: "Increase movement speed by 5%",
		3: "Increase movement speed by 5%",
		4: "Increase movement speed by 5%"
	},
	"pick_up_range": {
		1: "Increase pickup range by 20%",
		2: "Increase pickup range by 20%",
		3: "Increase pickup range by 20%",
		4: "Increase pickup range by 20%",
		5: "Increase pickup range by 20%",
		6: "Increase pickup range by 20%",
		7: "Increase pickup range by 20%"
	},
	"ooze": {
	1: "Increase damage by 5",
	2: "Increase ooze size by 25%",
	3: "Decrease damage interval by 0.25s",
	4: "Double the pulse limit",
	5: "Reduce drop cooldown by 1.0s",
	6: "Further decrease damage interval by 0.5s",
	7: "Triple the pulse limit",
	8: "Increase ooze size by 75%",
	9: "Increase damage by 10"
},
	"emp": {
		1: "Increase freeze time by 1.0s",
		2: "Increase effect area by 50%",
		3: "Reduce cooldown by 0.5s",
		4: "Increase effect area by 100%",
		5: "Increase freeze time by 2.0s",
		6: "Reduce cooldown by 0.5s",
		7: "Increase freeze time by 3.0s",
		8: "Increase effect area by 200%"
	},
	"shotgun": {
		1: "Increase damage by 5",
		2: "Increase projectile count by 2",
		3: "Reduce shot interval by 0.25s",
		4: "Increase projectile speed by 25%",  
		5: "Increase projectile count by 2",
		6: "Reduce shot interval by 0.5s",
		7: "Increase damage by 10",
		8: "Increase projectile speed by 50%",  
		9: "Increase projectile count by 2"
	},
	"boomerang": {
		1: "Increase max number of boomerangs by one",
		2: "Boomerangs now ricochet to two additional enemies before returning",
		3: "Doubles the projectile speed",
		4: "Increase max number of boomerangs by two",
		5: "Boomerangs now ricochet to four additional enemies before returning"
	},
	"crossbow": {
		1: "Increase reflections by 1",
		2: "Increase weapon damage by 5",
		3: "Increase projectile speed by 50%",
		4: "Increase reflections by 1",
		5: "Reduce shoot cooldown by 0.25",
		6: "Increase weapon damage by 10",
		7: "Increase reflections by 1"
	},
	# miscellaneous
	"coins": {
		1: "Gain 30 coins"
	}
}

const ABILITY_SCENE_PATH:Dictionary = {
	# Damaging abilities
	"radiation": "res://scenes/ability/passive/radiation.tscn",
	"plasma_gun": "res://scenes/ability/active/plasma_gun.tscn",
	"ooze": "res://scenes/ability/passive/ooze.tscn",
	"crossbow": "res://scenes/ability/active/crossbow.tscn",
	# Non-damaging abilities
	"emp" : "res://scenes/ability/passive/emp.tscn",
	"orbital_beam": "res://scenes/ability/passive/orbital_beam.tscn",
	"shotgun": "res://scenes/ability/passive/shotgun.tscn",
	"boomerang": "res://scenes/ability/active/boomerang.tscn",	
}

const ABILITY_ASSET_PATH: Dictionary = {
	# Damaging abilities
	"radiation": "res://assets/hud/ability_icons/Radiation.png",
	"plasma_gun": "res://assets/weapons/blue_laser_gun.png",
	"orbital_beam": "res://assets/enemy/turret/Bullet.png",
	"ooze" : "res://assets/hud/ability_icons/ooze.png",
	"shotgun": "res://assets/weapons/shotgun/AdjustedShotgun.png",
	"boomerang": "res://assets/weapons/boomerang/Boomerang.png",
	"crossbow": "res://assets/weapons/crossbow/CrossbowLoaded.png",
	
	# Non-damaging abilitites
	"emp": "res://assets/hud/ability_icons/EMP.png",
	"max_health": "res://assets/hud/ability_icons/Heart.png",
	"health_regen": "res://assets/hud/ability_icons/HeartWithGreenPlus.png",
	"pick_up_range": "res://assets/hud/ability_icons/Magnet.png",
	"shield": "res://assets/hud/ability_icons/Shield.png",
	"movement_speed": "res://assets/hud/ability_icons/MovementSpeed.png",
	
	# miscellaneous
	"coins": "res://assets/hud/Coins/CoinStack.png"
}

const ABILITY_DESCRIPTIONS: Dictionary = {
	# Damaging abilities
	"radiation": "Adds a damaging area around the player",
	"plasma_gun": "Default plasma gun",
	"orbital_beam": "Orbits player firing a beam",
	"ooze": "Drops some toxic ooze on the ground",
	
	# Non-damaging abilities
	"emp": "Stuns enemies that enter its area",
	"max_health": "Provides a boost to max health",
	"health_regen": "Provides health regen over time",
	"pick_up_range": "Increases the radius that the player can pick up items",
	"shield": "Provides temporary invulnerability after taking damage",
	"movement_speed": "Increases player movement speed",
	"shotgun": "fires multiple projectiles in quick bursts.",
	"boomerang": "Fire projectiles that return after reaching their destination",
	"crossbow": "Fires bouncing disks that ricochet off walls",
	
	# miscellaneous
	"coins": "Coins that can be used to purchase permanent upgrades from the shop"
}

const MAX_ABILITY_QTY: Dictionary = {
	# Damaging abilities
	"radiation": 9,
	"plasma_gun": 9,
	"orbital_beam": 9,
	"ooze": 9,
	"shotgun": 9,
	"boomerang": 5,
	"crossbow": 7,
	
	# Non-damaging abilities
	"emp": 8,
	"max_health": 9,
	"health_regen": 5,
	"pick_up_range": 7,
	"shield": 5,
	"movement_speed": 4,
	
	# miscellaneous
	"coins": 1
}

const PASSIVE_ABILITIES_NAMES: Array[String] = [
	"max_health", "health_regen", "pick_up_range", "shield", "movement_speed"
]

const ACTIVE_ABILITIES_NAMES: Array[String] = [
	"radiation", "plasma_gun", "emp", "orbital_beam", "ooze",
	"shotgun", "boomerang", "crossbow"
]
	

const MINIMUM_SHIELD_CD: float = 0.5

### Variables ###
var allMaxed = false
var movement_speed_buff: float = 0.05
var max_health_buff: float = 0.05
var health_regen_buff: float = 0.2
var pick_up_buff: float = 0.2
var shield_duration_buff: float = 1.0
var shield_cd_buff: float = 0.3
var player: Player
var hud: Hud 



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
		player.abilities[ability_key] = "passive"
		player.ability_qty[ability_key] = 1
		hud.addAbility(ability_key)
		give_passive_boost(ability_key, player.ability_qty[ability_key])
	else:
		if player.ability_qty[ability_key] < MAX_ABILITY_QTY[ability_key]:
			player.ability_qty[ability_key] += 1
			#hud.addAbility(ability_key)
			give_passive_boost(ability_key, player.ability_qty[ability_key])

func give_passive_boost(ability_name: String, qty: int):
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
			upgrade_shield(qty)
			
func give_active_ability(ability_key: String) -> void:
	if not player.abilities.has(ability_key) or not player.abilities[ability_key]:
		var ability_scene: PackedScene = load(AbilityObserver.get_ability_path(ability_key))
		var ability_instance = ability_scene.instantiate()
		if not ability_instance is Ooze:
			player.add_child(ability_instance)
		player.abilities[ability_key] = ability_instance
		player.ability_qty[ability_key] = 1
		hud.addAbility(ability_key)
		if ability_instance is Weapon:
			player.weapon_slots.append(ability_instance)
	else:
		if player.ability_qty[ability_key] < MAX_ABILITY_QTY[ability_key]:
			player.ability_qty[ability_key] += 1
			#hud.addAbility(ability_key)
	var ability = player.abilities[ability_key] 
	if ability.has_method("update_stat") and not ability_key == "ooze":
		ability.update_stat(player.ability_qty[ability_key])
		


func set_primary_weapon(ability_key: String) -> void:
	if player.primary_weapon != null:
		player.primary_weapon.set_auto(true)
		player.primary_weapon.hide_aim_line()
	player.set_primary_weapon(ability_key)
	player.primary_weapon.set_auto(false)
	player.primary_weapon.show_aim_line()

func hide_all_secondary() -> void:
	for weapon in player.abilities:
		if weapon is Weapon:
			weapon.hide_aim_line()

func set_movement_speed_buff() -> void:
	var multiplier = 1 + (movement_speed_buff * player.ability_qty["movement_speed"])
	var new_speed = (player.INITIAL_SPEED * multiplier)
	player.set_speed(new_speed)

func set_max_health_buff() -> void:
	var multiplier = 1 + (max_health_buff * player.ability_qty["max_health"])
	var new_health = (player.INITIAL_MAX_XP * multiplier)
	player.set_max_health(new_health)

func set_health_regen_buff() -> void:
	#level 2 0.2 * 2 = 0.4
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
	if new_cd >= MINIMUM_SHIELD_CD:
		player.set_shield_cd(new_cd)

func upgrade_shield(qty: int) -> void:
	match qty:
		1:
			set_shield_duration_buff()
		2: 
			set_shield_cd_buff()
		3:
			set_shield_duration_buff()
		4:
			set_shield_cd_buff()
		5: 
			set_shield_duration_buff()

func give_radiations() -> void:
	for i in range(player.radiation_level):
		AbilityObserver.give_active_ability("radiation")
		
func give_oribital_beams() -> void:
	for i in range(player.orbital_beam_level):
		AbilityObserver.give_active_ability("orbital_beam")

func give_emps() -> void:
	for i in range(player.emp_level):
		AbilityObserver.give_active_ability("emp")

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

func give_shields() -> void:
	for i in range(player.shield_level):
		AbilityObserver.give_passive_ability("shield")

func give_default_gun() -> void:
	for i in range(player.default_weapon_level):
		AbilityObserver.give_active_ability("plasma_gun")

func give_oozes() -> void:
	for i in range(player.ooze_level):
		AbilityObserver.give_active_ability("ooze")

func give_shotguns() -> void:
	for i in range(player.shotgun_level):
		AbilityObserver.give_active_ability("shotgun")

func give_crossbows() -> void:
	for i in range(player.crossbow_level):
		AbilityObserver.give_active_ability("crossbow")

func give_test_gun() -> void:
	for i in range(player.test_gun_level):
		AbilityObserver.give_active_ability("test_gun")

func giveBoomerangs() -> void:
	for i in range(player.boomerang_level):
		AbilityObserver.give_active_ability("boomerang")

func giveCrossbows() -> void:
	for i in range(player.crossbow_level):
		AbilityObserver.give_active_ability("crossbow")

func give_init_abilities():
	give_default_gun()
	give_radiations()
	give_movement_speeds()
	give_max_healths()
	give_health_regens()
	give_pick_up_ranges()
	give_shields()
	give_emps()
	give_test_gun()
	give_oribital_beams()
	give_oozes()
	give_shotguns()
	giveBoomerangs()
	giveCrossbows()

func give_random_pasive_abiity() -> void:
	var random_name = PASSIVE_ABILITIES_NAMES.pick_random()
	print("Given: " + random_name)
	give_passive_ability(random_name)

func give_random_active_abiity() -> void:
	var random_name = ACTIVE_ABILITIES_NAMES.pick_random()
	print("Given: " + random_name)
	give_active_ability(random_name)

func give_random_ability() -> void:
	var rnum = randi_range(1,2)
	if rnum == 1:
		give_random_active_abiity()
	else: 
		give_random_pasive_abiity()

func give_ability_selection() -> void:
	if player.abilities.size() < 8 || !allMaxed:
		hud.setChoice()
		get_tree().set_pause(true)
