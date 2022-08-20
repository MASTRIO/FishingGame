extends Spatial

func _on_WarpyNess_body_entered(body):
	if body.is_in_group("Player"):
		SceneManager.change_scene(Global.LEVELS[0])
		#get_tree().change_scene_to(Global.LEVELS[0])
