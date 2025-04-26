extends Node2D


### Variables ###
var clickable: bool = false
var rewardAvailable: bool = true
var skippable: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_tree().paused && get_parent().chest && !self.is_visible():
		pause_game_music()
		$PickUpSound.pitch_scale = randf_range(0.9,1.1)
		$PickUpSound.play()
		
		$ChestAnimator.play("RESET")
		$RewardAnimator.play("RESET")
		$ButtonAnimator.play("RESET")
		self.show()
		$ChestAnimator.play("OpenChest")
		$AnimationDelay.start()
		$RewardSound.pitch_scale = randf_range(1.1,1.2)
		$RewardSound.play()
		await $AnimationDelay.timeout
		
		if !rewardAvailable:
			print("First pass")
		else:
			$Reward.play("rotation")
			$RewardAnimator.play("Reward_Rise")
			await $RewardAnimator.animation_finished
			###
			### ADD CODE TO STOP THE SPRITE ON THE CORRECT ABILITY
			###
			if !rewardAvailable:
				print("Second pass")
			else:
				skippable = false
				giveRandomUpgrade()
				$AnimationDelay.start()
				await $AnimationDelay.timeout
				$ButtonAnimator.play("FadeInButton")

func _input(event: InputEvent) -> void:
	if event.is_action("pause_game") && rewardAvailable && self.is_visible() && skippable:
		rewardAvailable = false
		$RewardAnimator.stop()
		$ChestAnimator.stop()
		$ButtonAnimator.stop()
		$Reward.play("rotation")
		$RewardAnimator.play("End")
		$ChestAnimator.play("End")
		giveRandomUpgrade()
		$Reward.show()
		$RewardLabel.show()
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
		setSprite("coins")
		setLabel("coins")
		PlayerObserver.coins += 30
		print("Number of coins = " + str(PlayerObserver.coins))
		print("All available abilities are max upgraded")

# Function to determine what sprite to show
func setSprite(a_name: String) -> void:
	$Reward.stop()
	match a_name:
		"radiation":
			$Reward.frame = 12
		"plasma_gun":
			$Reward.frame = 4
		"emp":
			$Reward.frame = 0
		"max_health":
			$Reward.frame = 1
		"health_regen":
			$Reward.frame = 8
		"pick_up_range":
			$Reward.frame = 2
		"shield":
			$Reward.frame = 5
		"movement_speed":
			$Reward.frame = 3
		"ooze":
			$Reward.frame = 6
		"orbital_beam":
			$Reward.frame = 7
		"shotgun":
			$Reward.frame = 9
		"crossbow":
			$Reward.frame = 10
		"boomerang":
			$Reward.frame = 11
		"coins":
			$Reward.frame = 13

# Function to determine what name to add to the reward label
func setLabel(a_name: String) -> void:
	$RewardLabel.set_text("YOU GOT" + "\n" + a_name.replace("_", " ").to_upper())
func _on_click_area_pressed() -> void:
	if clickable:
		clickable = false
		rewardAvailable = true
		skippable = true
		get_parent().setChest()
		self.hide()
		get_tree().set_pause(false)
		unpause_game_music()


func _on_button_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeInButton":
		clickable = true

func pause_game_music() -> void:
	var player: Player = PlayerObserver.player
	var game_music: AudioStreamPlayer2D = player.get_node("GameMusic")
	game_music.stream_paused = true
	pass

func unpause_game_music() -> void:
	var player: Player = PlayerObserver.player
	var game_music: AudioStreamPlayer2D = player.get_node("GameMusic")
	game_music.stream_paused = false
	pass


func _on_reward_sound_finished() -> void:
	$ItemRewardSound.play()
	pass # Replace with function body.

func _on_chest_shake_sound_finished() -> void:
	$RewardSound.pitch_scale = randf_range(0.9,1.1)
	$RewardSound.play()
	pass # Replace with function body.
