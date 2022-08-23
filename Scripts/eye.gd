extends Spatial

signal eye_seen

func _ready():
	if Global.has_been_to_the_stairs:
		show()
	else:
		hide()

func _on_VisibilityNotifier_screen_entered():
	if Global.has_been_to_the_stairs:
		show()
		emit_signal("eye_seen")
		print("a")

func _on_VisibilityNotifier_screen_exited():
	hide()
