extends Node2D

### Variables ###
var clickable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().paused && get_parent().chest && !self.is_visible():
		$ChestAnimator.play("RESET")
		$RewardAnimator.play("RESET")
		$ButtonAnimator.play("RESET")
		self.show()
		$ChestAnimator.play("OpenChest")
		$AnimationDelay.start()
		await $AnimationDelay.timeout
		$Reward.play("rotation")
		$RewardAnimator.play("Reward_Rise")
		await $RewardAnimator.animation_finished
		###
		### ADD CODE TO STOP THE SPRITE ON THE CORRECT ABILITY
		###
		giveRandomUpgrade()
		$AnimationDelay.start()
		await $AnimationDelay.timeout
		$ButtonAnimator.play("FadeInButton")

# Function to give the player a random upgrade for an ability they already have
func giveRandomUpgrade() -> void:
	var available: Array[String] = []
	for key in PlayerObserver.player.ability_qty.keys():
		var qty = PlayerObserver.player.ability_qty.get(key)
		if qty < AbilityObserver.MAX_ABILITY_QTY.get(key):
			available.append(key)
	if !available.is_empty():
		var abilityName: String = available.pick_random()
		var ability = PlayerObserver.player.abilities.get(abilityName)
		if ability is PackedScene:
			AbilityObserver.give_active_ability(abilityName)
		else:
			AbilityObserver.give_passive_ability(abilityName)
		setSprite(abilityName)
		setLabel(abilityName)
	else:
		print("All available abilities are max upgraded")

# Function to determine what sprite to show
func setSprite(a_name: String) -> void:
	$Reward.stop()
	match a_name:
		"garlic":
			$Reward.frame = 1
		"plasma_gun":
			$Reward.frame = 4
# Function to determine what name to add to the reward label
func setLabel(a_name: String) -> void:
	$RewardLabel.set_text("YOU GOT" + "\n" + a_name.replace("_", " ").to_upper())
func _on_click_area_pressed() -> void:
	if clickable:
		self.hide()
		clickable = false
		get_parent().setChest()
		get_tree().set_pause(false)


func _on_button_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeInButton":
		clickable = true
