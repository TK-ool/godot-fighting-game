extends CharacterBody2D

signal device_id(player_id:int)

const SPEED = 300.0
const JUMP_VELOCITY = -600.0


const Dashspeed = 1200
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.RIGHT

@export var health_data: HealthResource
@export var device : int = 0
var deadzone : int = 0.2


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor() and is_dashing == false:
		velocity += get_gravity() * delta

	# Handle jump.
	if is_dashing == false:
		if Input.is_action_pressed("P%d_jump" % [device]) and is_on_floor() :
			print("player %d jump" % device)
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_joy_axis(device,JOY_AXIS_LEFT_X)
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()
	dash()
	
func _ready() -> void:
	device_id.emit(device)
	health_data = health_data.duplicate()
	
	
func dash():
	
	var input_direction: Vector2 = Vector2(
		Input.get_joy_axis(device, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(device, JOY_AXIS_LEFT_Y)
	).normalized() #normalize X and Y values können nicht weniger als -1 pder mehr als +1 sein
	
	#letzte richtung wird gespeichert
	if input_direction.x != 0:
		dash_direction.x = input_direction.x
		
	if Input.is_action_just_pressed("P%d_dash" % device) and can_dash == true:
		var final_dash_direction: Vector2 = dash_direction
		if input_direction.y != 0 and input_direction.x == 0: # damit bei oben, unten dash kein horizontaler movement dazukomment da Input direktion für richtung über oder unter 0 gespeichert wird
			final_dash_direction.x = 0
		final_dash_direction.y = input_direction.y
		
		can_dash = false
		is_dashing = true
		$Dash_Timer.start()
		#$Dash_cooldown.start()
		
		velocity = final_dash_direction * Dashspeed
		
	if is_on_floor():
		can_dash = true

func _on_dash_timer_timeout() -> void:
	is_dashing = false

#func _on_dash_cooldown_timeout() -> void:
	#can_dash = true

func _on_hit_area_area_entered(area: Area2D) -> void:
	print(device, " got hit")
	if area.is_in_group("bullet"):
		health_data.take_damage(1)
		area.queue_free()
