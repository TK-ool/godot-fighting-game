extends CharacterBody2D

signal device_id(player_id:int)

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
@export var device : int = 0
var deadzone : int = 0.2


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("P%d_jump" % [device]) and is_on_floor() :
		print("player %d jump" % device)
		velocity.y = JUMP_VELOCITY

	
	var direction := Input.get_joy_axis(device,JOY_AXIS_LEFT_X)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	
func _ready() -> void:
	device_id.emit(device)
	
