extends Spatial

onready var fishing_line = $FishingLine
onready var hook_display = $HookDisplay

var fish_caught = 0
var cash_money = 0

var can_sell = false

func _ready():
	fishing_line.points = []

func _process(_delta):
	$World/Shop/Amogus2.rotation = (-$Player/RotationPivot.rotation + -$Player.rotation)
	
	$UI.visible = not Input.is_action_pressed("hide_ui")
	
	$UI/LaunchPower.visible = Input.is_action_pressed("fish")
	$UI/E.visible = can_sell
	
	$UI/LaunchPower.text = str($Player.launch_power / 10)
	$UI/FishCaught.text = "Fish Caught: " + str(fish_caught)
	$UI/MoneyCash.text = "Cash Money: " + str(cash_money)
	
	if is_instance_valid($FishingHook):
		if not $FishingHook.is_queued_for_deletion():
			var fishing_hook_pos = $Player/RotationPivot/Camera.unproject_position($HookDisplay/LinePos.global_transform.origin)
			
			# Hook display
			hook_display.global_transform.origin = $FishingHook.global_transform.origin
			
			# Fishing line
			if fishing_hook_pos < OS.window_size and fishing_hook_pos > Vector2(0, 0) and $FishingHook.visible:
				fishing_line.points = [
					$FishingLine/LineStartPos.position,
					fishing_hook_pos
				]
			else:
				fishing_line.points = []
				$FishingHook.queue_free()
	else:
		hook_display.global_transform.origin = Vector3(0, -10000, 0)

func _input(event):
	if event.is_action_pressed("interact"):
		if can_sell:
			for fish in fish_caught:
				randomize()
				cash_money += round(rand_range(1, 20))
				
				var amogus = preload("res://Objects/amogus.tscn").instance()
				amogus.global_transform.origin = $World/Shop/AmogusSpawn.global_transform.origin
				$Amogussy.add_child(amogus)
			fish_caught = 0

func _on_FishSpawnTimer_timeout():
	if is_instance_valid($FishingHook):
		var fish = preload("res://Objects/underwater_fish.tscn").instance()
		fish.global_transform.origin = $FishingHook.global_transform.origin
		add_child(fish)
		$FishSpawnTimer.stop()

func _on_SellZone_body_entered(body):
	if body.is_in_group("Player"):
		can_sell = true

func _on_SellZone_body_exited(body):
	if body.is_in_group("Player"):
		can_sell = false

func _on_ShopCulling_screen_entered():
	$World/Shop.show()

func _on_ShopCulling_screen_exited():
	$World/Shop.show()


func _on_BackroomsWarp_body_entered(body):
	if body.is_in_group("Player"):
		SceneManager.change_scene(Global.LEVELS[1])
		#get_tree().change_scene_to(Global.LEVELS[1])
