extends Spatial

onready var amogus = $Amogus
onready var player = $Player

func _process(_delta):
	amogus.rotation = player.rotation

func _on_WarpyWarp_body_entered(body):
	if body.is_in_group("Player"):
		SceneManager.change_scene(Global.LEVELS[3])
		#get_tree().change_scene_to(Global.LEVELS[3])
