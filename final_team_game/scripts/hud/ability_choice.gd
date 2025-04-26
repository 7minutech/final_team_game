extends Node2D

### Constants ###
const binaryChoice: Array[int] = [0,1]

### Variables ###
var clickable: bool = true
var a_list: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().paused && get_parent().choice && !self.is_visible():
		a_list = []
		getOptions()
		setIcons(a_list)
		setDescriptions(a_list)
		self.show()
		$LevelUpSound.pitch_scale = randf_range(0.9,1.1)
		$LevelUpSound.play()

### Functions for setting up buttons ###
func getOptions() -> void:
	if AbilityObserver.player.abilities.size() < 8:
		selectFrom(AbilityObserver)
	elif !AbilityObserver.allMaxed:
		selectFrom(AbilityObserver.player)
##
func setIcons(list: Array[String]) -> void:
	var num: int = 1
	for a_name in a_list:
		var icon = load(AbilityObserver.ABILITY_ASSET_PATH.get(a_name))
		var button: Button = self.find_child("Choice_" + str(num))
		button.set_text(a_name.capitalize())
		button.set_button_icon(icon)
		num += 1
##
func setDescriptions(list: Array[String]) -> void:
	var num: int = 1
	for a_name in a_list:
		# Description Labels
		var label: Label = self.find_child("Description_" + str(num))
		label.set_text("Description: \n" + AbilityObserver.ABILITY_DESCRIPTIONS.get(a_name))
		
		# Upgrade Labels
		label = self.find_child("Upgrade_" + str(num))
		var upgrade: Dictionary = AbilityObserver.ABILITY_UPGRADE_DESC.get(a_name)
		var upgradeNum: int = 1
		if AbilityObserver.player.ability_qty.has(a_name):
			upgradeNum = AbilityObserver.player.ability_qty.get(a_name) + 1
		label.set_text("Upgrade " + str(upgradeNum) + ": \n" + upgrade.get(upgradeNum))
		num += 1

##
func removeMaxedAbilities(list: Array[String]) -> Array[String]:
	var newList: Array[String] = list.duplicate(true)
	var maxedList: Array[String] = []
	var current_qtys: Dictionary = AbilityObserver.player.ability_qty
	for a: String in newList:
		if current_qtys.has(a):
			if current_qtys.get(a) >= AbilityObserver.MAX_ABILITY_QTY.get(a):
				maxedList.append(a)
	#print(maxedList)
	for maxed: String in maxedList:
		#print(newList)
		newList.erase(maxed)
	return newList
##
func selectFrom(location) -> void:
	if location is AbilityObserver:
		var actives_copy: Array[String] = AbilityObserver.ACTIVE_ABILITIES_NAMES.duplicate(true)
		var passives_copy: Array[String] = AbilityObserver.PASSIVE_ABILITIES_NAMES.duplicate(true)
		actives_copy = removeMaxedAbilities(actives_copy)
		passives_copy = removeMaxedAbilities(passives_copy)
		var active = actives_copy.pick_random()
		var passive = passives_copy.pick_random()
		a_list.append(active)
		a_list.append(passive)
		actives_copy.erase(active)
		passives_copy.erase(passive)
		var choice: int = binaryChoice.pick_random()
		match choice:
			0:
				a_list.append(actives_copy.pick_random())
			1:
				a_list.append(passives_copy.pick_random())
	elif location is Player:
		var abilities: Array[String] = []
		for key in location.abilities.keys():
			abilities.append(key)
		abilities = removeMaxedAbilities(abilities)
		for i in range(abilities.size()):
			if i < 3:
				var a = abilities.pick_random()
				a_list.append(a)
				abilities.erase(a)
			else:
				return
##


### Functions for button pressed logic ###
func buttonPressed() -> void:
	a_list = []
	get_parent().setChoice()
	self.hide()
	clickable = true
	get_tree().set_pause(false)
##
func nameValidation(a_name: String) -> bool:
	clickable = false
	a_name = a_name.replace(" ", "_").to_lower()
	if AbilityObserver.ACTIVE_ABILITIES_NAMES.has(a_name):
		AbilityObserver.give_active_ability(a_name)
		return true
	elif AbilityObserver.PASSIVE_ABILITIES_NAMES.has(a_name):
		AbilityObserver.give_passive_ability(a_name)
		return true
	else:
		clickable = true
		return false
##
func _on_choice_1_pressed() -> void:
	if clickable && nameValidation($Choice_1.get_text()):
		buttonPressed()
##
func _on_choice_2_pressed() -> void:
	if clickable &&  nameValidation($Choice_2.get_text()):
		buttonPressed()
##
func _on_choice_3_pressed() -> void:
	if clickable && nameValidation($Choice_3.get_text()):
		buttonPressed()
