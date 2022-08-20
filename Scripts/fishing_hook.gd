extends RigidBody

var spawned_fish = false

func _on_VisibilityNotifier_screen_entered():
	show()

func _on_VisibilityNotifier_screen_exited():
	hide()

func _on_GroundCollision_body_entered(body):
	print(body)
	if not body.is_in_group("NonHookStopping"):
		mode = RigidBody.MODE_CHARACTER
		
		if body.is_in_group("Water"):
			get_parent().get_node("HookDisplay/AnimationPlayer").play("Bobbin")
			
			var splash = preload("res://Particles/splashparticles.tscn").instance()
			splash.global_transform.origin = global_transform.origin
			get_parent().add_child(splash)
			
			if not spawned_fish:
				print("a")
				randomize()
				get_parent().get_node("FishSpawnTimer").wait_time = rand_range(5, 15)
				get_parent().get_node("FishSpawnTimer").start()
				spawned_fish = true
