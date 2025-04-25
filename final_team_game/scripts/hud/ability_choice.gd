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
		getOptions()
		setIcons(a_list)
		setDescriptions(a_list)
		self.show()


### Functions for setting up buttons ###
func getOptions() -> void:
	var actives_copy: Array[String] = AbilityObserver.ACTIVE_ABILITIES_NAMES.duplicate(true)
	var passives_copy: Array[String] = AbilityObserver.PASSIVE_ABILITIES_NAMES.duplicate(true)
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
		var label: Label = self.find_child("Description_" + str(num))
		label.set_text("")
		label.set_text(AbilityObserver.ABILITY_DESCRIPTIONS.get(a_name))
		num += 1


### Functions for button pressed logic ###
func buttonPressed() -> void:
	a_list = []
	get_parent().setChoice()
	self.hide()
	clickable = true
	get_tree().set_pause(false)
##
func nameValidation(a_name: String) -> bool:
	a_name = a_name.replace(" ", "_").to_lower()
	for a in AbilityObserver.ACTIVE_ABILITIES_NAMES:
		if a_name == a:
			AbilityObserver.give_active_ability(a_name)
			return true
	for a in AbilityObserver.PASSIVE_ABILITIES_NAMES:
		if a_name == a:
			AbilityObserver.give_passive_ability(a_name)
			return true
	return false
##
func _on_choice_1_pressed() -> void:
	if clickable && nameValidation($Choice_1.get_text()):
		clickable = false
		buttonPressed()
##
func _on_choice_2_pressed() -> void:
	if clickable &&  nameValidation($Choice_2.get_text()):
		clickable = false
		buttonPressed()
##
func _on_choice_3_pressed() -> void:
	if clickable && nameValidation($Choice_3.get_text()):
		clickable = false
		buttonPressed()
