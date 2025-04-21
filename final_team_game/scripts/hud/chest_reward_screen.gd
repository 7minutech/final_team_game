extends Node2D

### Variables ###
var clickable: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
		$AnimationDelay.start()
		await $AnimationDelay.timeout
		$ButtonAnimator.play("FadeInButton")


func _on_click_area_pressed() -> void:
	if clickable:
		self.hide()
		clickable = false
		get_parent().setChest()
		get_tree().set_pause(false)


func _on_button_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "FadeInButton":
		clickable = true
