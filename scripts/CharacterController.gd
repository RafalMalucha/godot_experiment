extends CharacterBody3D

@onready var head = $Head

@export var current_speed = 10.0
const JUMP_VELOCITY = 4.5
var lerp_speed = 10.0

var direction = Vector3.ZERO

const sensitivity = 1


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * sensitivity * -0.001)
		head.rotate_x(event.relative.y * sensitivity * -0.001)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	
	if Input.is_action_just_pressed("dash"):
		print('dash')
		current_speed = 20.0
		
		
	if Input.is_action_just_released('dash'):
		current_speed = 10.0
		
	if Input.is_action_just_pressed('pause'):
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
		
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta*lerp_speed)
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()
