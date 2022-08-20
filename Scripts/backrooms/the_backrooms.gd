extends Spatial

func _on_WarpLol_body_entered(body):
	if body.is_in_group("Player"):
		SceneManager.change_scene(Global.LEVELS[2])
		#get_tree().change_scene_to(Global.LEVELS[2])
