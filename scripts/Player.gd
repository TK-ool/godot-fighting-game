extends CharacterBody2D

signal device_id(player_id:int)

const SPEED = 300.0
const JUMP_VELOCITY = -600.0


const Dashspeed = 1000
var is_dashing: bool = false
var can_dash: bool = true

@export var health_data: HealthResource
@export var device : int = 0
var deadzone : int = 0.2


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor() and is_dashing == false:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("P%d_jump" % [device]) and is_on_floor() :
		print("player %d jump" % device)
		velocity.y = JUMP_VELOCITY

	
	var direction := Input.get_joy_axis(device,JOY_AXIS_LEFT_X)

	
	if direction:
		if is_dashing == true:
			velocity.x =  direction * Dashspeed
		else:
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	dash()
	
func _ready() -> void:
	device_id.emit(device)
	
func dash() :
	if Input.is_action_just_pressed("P%d_dash" % device) and can_dash == true:
		can_dash = false
		is_dashing = true
		$Dash_Timer.start()
		$Dash_cooldown.start()

func _on_dash_timer_timeout() -> void:
	is_dashing = false

func _on_dash_cooldown_timeout() -> void:
	can_dash = true

func _on_hit_area_area_entered(area: Area2D) -> void:
	print(device, " got hit")
	if area.is_in_group("bullet"):
		health_data.take_damage(1)
		area.queue_free()
