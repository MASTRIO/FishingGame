extends KinematicBody

onready var camera = $RotationPivot/Camera
onready var fish_point = $RotationPivot/FishPoint
onready var rotation_helper = $RotationPivot

const NORMAL_MOVE_SPEED = 8
const RUN_MOVE_SPEED = 24
var current_move_speed = NORMAL_MOVE_SPEED
const JUMP_HEIGHT = 15

var gravity = -30
var mouse_sensitivity = 0.002

const POWER_INCREASE = 10
var launch_power = 0

var velocity = Vector3()

var spawn_pos = Vector2()

func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("move_forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_backward"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		input_dir += camera.global_transform.basis.x
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y += JUMP_HEIGHT
	
	if Input.is_action_pressed("run"):
		current_move_speed = RUN_MOVE_SPEED
	else:
		current_move_speed = NORMAL_MOVE_SPEED
	
	input_dir = input_dir.normalized()
	return input_dir

func _ready():
	spawn_pos = global_transform.origin
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		rotation_helper.rotation.x = clamp(rotation_helper.rotation.x, -1.2, 1.2)

func _physics_process(delta):
	if Input.is_action_pressed("fish"):
		launch_power += POWER_INCREASE
	
	if Input.is_action_pressed("slam"):
		velocity.y += -1000 * delta
	else:
		velocity.y += gravity * delta
	
	var desired_velocity = get_input() * current_move_speed
	
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _input(event):
	if event.is_action_pressed("toggle_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_released("fish"):
		if is_instance_valid(get_parent().get_node("FishingHook")):
			get_parent().get_node("FishingHook").free()
		 
		var hook = preload("res://Objects/fishing_hook.tscn").instance()
		hook.global_transform.origin = fish_point.global_transform.origin
		hook.add_central_force(-global_transform.basis.z * launch_power)
		hook.rotation = camera.rotation
		get_parent().add_child(hook)
		launch_power = 0
	
	elif event.is_action_pressed("respawn"):
		global_transform.origin = spawn_pos
	
	elif event.is_action_pressed("zoom"):
		$AnimationPlayer.play("Zoom")
	elif event.is_action_released("zoom"):
		$AnimationPlayer.play_backwards("Zoom")
