extends Node2D

var player_ID : int = 0

@onready var sprite_2d: Sprite2D = $Sprite2D

var deadzone: float = 0.2
var rotation_speed: float = 5.0

var target_angle: float

func _process(delta: float) -> void:
	
	var input_vec: Vector2 = Vector2(
		Input.get_joy_axis(player_ID, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(player_ID, JOY_AXIS_RIGHT_Y)
	)
	
	if input_vec.length() >= deadzone:
		target_angle = input_vec.angle()
	
	if rotation != target_angle:
		rotation = target_angle
		
		 
		#code für übergang zum endpunkt
		#var rotation_lerp_weight: float = 1.0 - exp(-rotation_speed * delta)
		#rotation = lerp_angle(	rotation, target_angle, rotation_lerp_weight)
		
		flip_rotation()
		
func flip_rotation():
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees	< 270:
		sprite_2d.flip_v = true
	else:
		sprite_2d.flip_v = false


func _on_character_body_2d_device_id(player_id: int) -> void:
	print("Signal erhalten", player_id)
	player_ID = player_id
