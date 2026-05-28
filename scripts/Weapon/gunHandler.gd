class_name Gun
extends Node2D

var player_ID : int = 0

var face_right

var bullet
var bullet_casing

var all_guns: = [
preload("uid://bxwi8dex18vm8"), #Bouncegun
preload("uid://bohtx51vyqg3j"), #Handgun
preload("uid://cu3cv5885ctqs") #splitgun
]

@onready var reload_bar: ProgressBar = $"../Reload_bar"

@export var current_weapon: WeaponResource

@onready var gunshot: AudioStreamPlayer = $gunshot_sound
@onready var muzzleflash2d: AnimatedSprite2D = $Muzzleflash
@onready var muzzleflash: AnimationPlayer = $Muzzleflash/AnimationPlayer

@onready var bullet_casing_eject: Marker2D = $Sprite2D/Bullet_casing_eject
@onready var gunpoint_links: Marker2D = $Sprite2D/Marker2D2
@onready var gunpoint_rechts: Marker2D = $Sprite2D/Marker2D
@onready var gunsprite_2d: Sprite2D = $Sprite2D

var fire_rate: float #The amount of Time between Shots in Seconds
var bullet_amount: int #ammo
var bullet_spread: float
var bullet_speed: float
var magazine_size: int
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
	bullet_casing_eject.position = weapon.casing_eject_point
	
	fire_rate = current_weapon.fire_rate
	bullet_amount = current_weapon.magazine_size
	magazine_size = current_weapon.magazine_size
	reload_bar.max_value = current_weapon.reload_time
	bullet = current_weapon.Bullet_scene
	bullet_casing = current_weapon.bullet_casing_scene
	bullet_spread = current_weapon.bullet_spread
	bullet_speed = current_weapon.bullet_speed

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
		bullet_instance.device = player_ID
		bullet_instance.behaviours = current_weapon.behaviours
		bullet_instance.damage = current_weapon.damage
		bullet_instance.speed = bullet_speed
		muzzleflash.play("muzzleflash")
		gunshot.play(0.0)
		bullet_amount -= 1
		spawn_bullet_casing()
		if face_right == true:
			bullet_instance.global_position = gunpoint_links.global_position
		else:
			bullet_instance.global_position = gunpoint_rechts.global_position
		var final_bullet_spread = randf_range(bullet_spread, -bullet_spread)
		bullet_instance.global_rotation = global_rotation + final_bullet_spread
		get_tree().root.add_child(bullet_instance)
		
func spawn_bullet_casing():
	if bullet_casing == null:
		return
	else:
		var bullet_casing_instance = bullet_casing.instantiate()
		var bullet_casing_velocity = Vector2(randf_range(-310.47, -200),randf_range(-362.925,-200))
		var bullet_casing_angular_velocity = randf_range(425, 900)
		bullet_casing_instance.linear_velocity = bullet_casing_velocity
		bullet_casing_instance.angular_velocity = bullet_casing_angular_velocity
		bullet_casing_instance.global_position = bullet_casing_eject.global_position

		if face_right == true:
			bullet_casing_instance.linear_velocity.x = bullet_casing_instance.linear_velocity.x * 1
		else:
			bullet_casing_instance.linear_velocity.x = bullet_casing_instance.linear_velocity.x * -1

		get_tree().root.add_child(bullet_casing_instance)
	
	
func reload():
	if Input.is_action_just_pressed("P%d_reload" % player_ID) and !is_reloading and bullet_amount != current_weapon.magazine_size or Input.is_action_just_pressed("P%d_shoot" % player_ID) and bullet_amount <= 0 and !is_reloading:
		reload_timer = current_weapon.reload_time
		print(	"reload pressed")
		is_reloading = true
	if is_reloading and reload_timer <= 0.0:
		print("reloaded")
		bullet_amount = current_weapon.magazine_size
		is_reloading = false

func reload_progress():
	if is_reloading:
		reload_bar.visible = true
		reload_bar.value = reload_timer
	else:
		reload_bar.visible = false
		

func new_weapon(weapon_selected: int):
	var debug_menu = get_parent().get_parent().get_node("DebugMenu")
	current_weapon = all_guns[weapon_selected]
	get_parent().inventory.add_card(current_weapon)
	equip_weapon(current_weapon)
	
	if player_ID == 0:
		debug_menu.update_inventory_display_1(get_parent().inventory)
	else:
		debug_menu.update_inventory_display_2(get_parent().inventory)
	
func debug():
	var debug_menu = get_parent().get_parent().get_node("DebugMenu")
	if player_ID == 0:
		debug_menu.weapon_equiped_P1.connect(new_weapon)
	else:
		debug_menu.weapon_equiped_P2.connect(new_weapon)



func _on_character_body_2d_device_id(player_id: int) -> void:
	print("Signal erhalten", player_id)
	player_ID = player_id
	debug() # zuweisung des menüs nach Player ID zuweisung
	
func signal_erhalten():
	print("signal in gun erhalten")
