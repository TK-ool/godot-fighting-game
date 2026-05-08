extends Node2D

var player_ID : int = 0

var face_right

const Bullet = preload("res://scenen/bullet.tscn")

@export var current_weapon: WeaponResource

@onready var gunpoint_links: Marker2D = $Sprite2D/Marker2D2
@onready var gunpoint_rechts: Marker2D = $Sprite2D/Marker2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var fire_rate: float #The amount of Time between Shots in Seconds
var _cooldown_timer = 0.0

var deadzone: float = 0.2
var rotation_speed: float = 5.0

var target_angle: float

func _ready() -> void:
	equip_weapon(current_weapon)

func _process(_delta: float) -> void:
	
	
	decrease_cooldown(_delta)
	
	var input_vec: Vector2 = Vector2(
		Input.get_axis("P%d_links_rechts" % player_ID, "P%d_rechts_rechts" % player_ID),
		Input.get_axis("P%d_oben_rechts" % player_ID, "P%d_unten_rechts" % player_ID)
		)
	
	if input_vec.length() >= deadzone:
		target_angle = input_vec.angle()
	
	if rotation != target_angle:
		rotation = target_angle
		
		 
		#code für übergang zum endpunkt
		#var rotation_lerp_weight: float = 1.0 - exp(-rotation_speed * delta)
		#rotation = lerp_angle(	rotation, target_angle, rotation_lerp_weight)
		
	flip_rotation()
	Shoot()

func equip_weapon(weapon: WeaponResource):
	current_weapon = weapon # set weapon from Resource
	sprite_2d.texture = current_weapon.weapon_sprite
	# set weapon offset for gunpoint
	gunpoint_links.position = weapon.gunpoint_offset_left
	gunpoint_rechts.position = weapon.gunpoint_offset_right
	
	fire_rate = current_weapon.fire_rate
	# set attributes
	#current_weapon.damage = Bullet.damage
	#current_weapon.fire_rate = 
	#bullet_speed
	#bullet_amount
	#magazine_size

func decrease_cooldown(_delta: float):
	if _cooldown_timer > 0:
		_cooldown_timer -= _delta

func can_fire() -> bool:
	return _cooldown_timer <= 0.0

func flip_rotation():
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees	< 270:
		sprite_2d.flip_v = true
		face_right = false
		
	else:
		sprite_2d.flip_v = false
		face_right = true
		
func Shoot():
	if Input.is_action_pressed("P%d_shoot" % player_ID) and can_fire():
		_cooldown_timer = fire_rate
		var bullet_instance = Bullet.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.device = player_ID
		bullet_instance.set_group()
		bullet_instance.behaviours = current_weapon.behaviours
		bullet_instance.damage = current_weapon.damage
		if face_right == true:
			bullet_instance.global_position = gunpoint_rechts.global_position
		else:
			bullet_instance.global_position = gunpoint_links.global_position
		bullet_instance.rotation = rotation
	

func _on_character_body_2d_device_id(player_id: int) -> void:
	print("Signal erhalten", player_id)
	player_ID = player_id
	
func signal_erhalten():
	print("signal in gun erhalten")
