extends RigidBody

func _on_VisibilityNotifier_camera_entered(camera):
	show()

func _on_VisibilityNotifier_camera_exited(camera):
	hide()
