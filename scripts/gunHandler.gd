extends Node2D

var player_ID : int = 0

var face_right

var bullet

@onready var reload_bar: ProgressBar = $"../Reload_bar"

@export var current_weapon: WeaponResource

@onready var gunshot: AudioStreamPlayer = $gunshot_sound
@onready var muzzleflash2d: AnimatedSprite2D = $Muzzleflash
@onready var muzzleflash: AnimationPlayer = $Muzzleflash/AnimationPlayer

@onready var gunpoint_links: Marker2D = $Sprite2D/Marker2D2
@onready var gunpoint_rechts: Marker2D = $Sprite2D/Marker2D
@onready var gunsprite_2d: Sprite2D = $Sprite2D

var fire_rate: float #The amount of Time between Shots in Seconds
var bullet_amount: int #ammo
var reload_timer: float = 0.0
var is_reloading: bool = false
var _cooldown_timer = 0.0

var deadzone: float = 0.2
var rotation_speed: float = 5.0

var target_angle: float

func _ready() -> void:
	equip_weapon(current_weapon)

func _process(delta: float) -> void:
	
	
	decrease_cooldown(delta)
	
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
	reload()
	reload_progress()

func equip_weapon(weapon: WeaponResource):
	current_weapon = weapon # set weapon from Resource
	gunsprite_2d.texture = current_weapon.weapon_sprite
	# set weapon offset for gunpoint
	gunpoint_links.position = weapon.gunpoint_offset_left
	gunpoint_rechts.position = weapon.gunpoint_offset_right
	
	fire_rate = current_weapon.fire_rate
	bullet_amount = current_weapon.bullet_amount
	reload_bar.max_value = current_weapon.reload_time
	bullet = current_weapon.Bullet_scene
	# set attributes
	#current_weapon.damage = Bullet.damage
	#current_weapon.fire_rate = 
	#bullet_speed
	#bullet_amount
	#magazine_size

func decrease_cooldown(delta: float):
	if _cooldown_timer > 0:
		_cooldown_timer -= delta
	if reload_timer > 0:
		reload_timer -= delta
		

func can_fire() -> bool:
	return _cooldown_timer <= 0.0
	

func flip_rotation():
	rotation_degrees = wrap(rotation_degrees, 0, 360)
	if rotation_degrees > 90 and rotation_degrees	< 270:
		gunsprite_2d.flip_v = true
		face_right = false
		muzzleflash2d.global_position = gunpoint_rechts.global_position
	else:
		gunsprite_2d.flip_v = false
		face_right = true
		muzzleflash2d.global_position = gunpoint_links.global_position
		
		
func Shoot():
	if Input.is_action_pressed("P%d_shoot" % player_ID) and can_fire() and bullet_amount > 0 and !is_reloading:
		_cooldown_timer = fire_rate
		var bullet_instance = bullet.instantiate()
		get_tree().root.add_child(bullet_instance)
		bullet_instance.device = player_ID
		bullet_instance.set_group()
		bullet_instance.behaviours = current_weapon.behaviours
		bullet_instance.damage = current_weapon.damage
		muzzleflash.play("muzzleflash")
		gunshot.play(0.0)
		bullet_amount -= 1
		if face_right == true:
			bullet_instance.global_position = gunpoint_links.global_position
		else:
			bullet_instance.global_position = gunpoint_rechts.global_position
		bullet_instance.rotation = rotation
		
func reload():
	if Input.is_action_just_pressed("P%d_reload" % player_ID) and !is_reloading or Input.is_action_just_pressed("P%d_shoot" % player_ID) and bullet_amount <= 0 and !is_reloading:
		reload_timer = current_weapon.reload_time
		print(	"reload pressed")
		is_reloading = true
	if is_reloading and reload_timer <= 0.0:
		print("reloaded")
		bullet_amount = current_weapon.bullet_amount
		is_reloading = false

func reload_progress():
	if is_reloading:
		reload_bar.visible = true
		reload_bar.value = reload_timer
	else:
		reload_bar.visible = false
	




func _on_character_body_2d_device_id(player_id: int) -> void:
	print("Signal erhalten", player_id)
	player_ID = player_id
	
func signal_erhalten():
	print("signal in gun erhalten")
