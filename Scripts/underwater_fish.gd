extends Spatial

func _physics_process(_delta):
	if is_instance_valid(get_parent().get_node("FishingHook")):
		if global_transform.origin != get_parent().get_node("FishingHook").global_transform.origin:
			queue_free()
	else:
		queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "CatchFish":
		if is_instance_valid(get_parent().get_node("FishingHook")):
			queue_free()
			get_parent().get_node("FishingHook").queue_free()
			get_parent().get_node("FishingLine").points = []
			get_parent().fish_caught += 1
