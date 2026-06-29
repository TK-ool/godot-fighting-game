class_name Gun
extends Node2D

var player_ID : int = 0

var face_right

var bullet
var bullet_casing

var all_guns: = [
preload("uid://y6rwdpy5crvv"),  #No Gun 0
preload("uid://bohtx51vyqg3j"), #Handgun 1
preload("uid://cu3cv5885ctqs"), #splitgun 2
preload("uid://b1egicpbk2pcj"), #shuriken 3
preload("uid://t7mmt3f7xruq"),  #Machine Gun 4
preload("uid://bxwi8dex18vm8")  #Bouncegun 5
]

@onready var reload_bar: ProgressBar = $"../Reload_bar"

@export var current_weapon: WeaponResource


@onready var weapon_smoke: GPUParticles2D = $WeaponSmoke # bei verlieren der Waffe

@onready var gunshot: AudioStreamPlayer = $gunshot_sound
@onready var gunreload_sound: AudioStreamPlayer = $gunreload_sound
@onready var muzzleflash2d: AnimatedSprite2D = $Muzzleflash
@onready var muzzleflash: AnimationPlayer = $Muzzleflash/AnimationPlayer

@onready var bullet_casing_eject: Marker2D = $Sprite2D/Bullet_casing_eject
@onready var gunpoint_links: Marker2D = $Sprite2D/Marker2D2
@onready var gunpoint_rechts: Marker2D = $Sprite2D/Marker2D
@onready var gunsprite_2d: Sprite2D = $Sprite2D

var fire_rate: float #The amount of Time between Shots in Seconds
var bullet_amount: int # derzeitige anzahl der kugeln
var bullet_spread: float
var visuell_recoil:int
var bullet_speed: float
var multishoot: bool = false
var multishoot_amount: int
var multishoot_arc: float 
var magazine_amount: int # anzahl der magazine
var magazine_size: int # größe des magazines
var muzzleflash_anim: String
var reload_timer: float = 0.0
var is_reloading: bool = false
var _cooldown_timer = 0.0

var deadzone: float = 0.2
var rotation_speed: float = 40.0

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
		#rotation = target_angle

		#code für übergang zum endpunkt
		var rotation_lerp_weight: float = 1.0 - exp(-rotation_speed * delta)
		rotation = lerp_angle(	rotation, target_angle, rotation_lerp_weight)
		
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
	magazine_amount = current_weapon.magazine_amount
	magazine_size = current_weapon.magazine_size
	reload_bar.max_value = current_weapon.reload_time
	bullet = current_weapon.Bullet_scene
	bullet_casing = current_weapon.bullet_casing_scene
	bullet_spread = current_weapon.bullet_spread
	visuell_recoil = current_weapon.visuell_recoil
	bullet_speed = current_weapon.bullet_speed
	multishoot = current_weapon.multishoot
	multishoot_amount = current_weapon.multishoot_amount
	multishoot_arc = current_weapon.multishoot_arc
	muzzleflash_anim = current_weapon.muzzleflash_anim
	
	# shoot audio
	gunshot.stream = current_weapon.shoot_sound # derzeit ersetzt es den ranomizer sound, also immer derselbe sound zurzeit ohne anpassung
	gunshot.volume_db = current_weapon.volume_db_offset_shoot
	gunshot.pitch_scale = current_weapon.pitch_scale_shoot
	
	#reload audio
	gunreload_sound.stream = current_weapon.reload_sound
	
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
		muzzleflash.play(muzzleflash_anim)
		gunshot.play(0.0)
		bullet_amount -= 1
		spawn_bullet_casing()
		if face_right == true:
			bullet_instance.global_position = gunpoint_links.global_position
		else:
			bullet_instance.global_position = gunpoint_rechts.global_position
		var final_bullet_spread = randf_range(bullet_spread, -bullet_spread) # für visuell reoil benutzt
		visuell_recoil_tween()
		
		if multishoot == true:
			for i in multishoot_amount:
				var b = bullet_instance.duplicate()
				var angle_increment = multishoot_arc / (multishoot_amount - 1) #  abstand zwischen den kugeln
				b.behaviours = current_weapon.behaviours # nur behaviour neu gesetzt sonst keine funltion // testen mit anderen werten falls notwendig
				b.device = player_ID
				b.behaviours = current_weapon.behaviours
				b.damage = current_weapon.damage
				b.speed = bullet_speed
				b.global_rotation = global_rotation + angle_increment * i - multishoot_arc / 2 #spreaded die kugeln gleichmäßig über den angle
				get_viewport().add_child(b)
		else:
			bullet_instance.device = player_ID
			bullet_instance.behaviours = current_weapon.behaviours
			bullet_instance.damage = current_weapon.damage
			bullet_instance.speed = bullet_speed
			bullet_instance.global_rotation = global_rotation + final_bullet_spread
			get_viewport().add_child(bullet_instance)
		
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

		get_viewport().add_child(bullet_casing_instance)
	
	
func reload():
	if magazine_amount <= 0 and bullet_amount <= 0 and current_weapon != all_guns[0] and (Input.is_action_just_pressed("P%d_shoot" % player_ID) or Input.is_action_just_pressed("P%d_reload" % player_ID)):# allguns 0 ist keine Waffe
		weapon_smoke.emitting = true
		equip_weapon(all_guns[0])
	elif magazine_amount <= 0:
		return
	if Input.is_action_just_pressed("P%d_reload" % player_ID) and !is_reloading and bullet_amount != current_weapon.magazine_size or Input.is_action_just_pressed("P%d_shoot" % player_ID) and bullet_amount <= 0 and !is_reloading:
		reload_timer = current_weapon.reload_time
		is_reloading = true
		gunreload_sound.play(0.0)
	if is_reloading and reload_timer <= 0.0:
		bullet_amount = current_weapon.magazine_size
		magazine_amount -= 1
		is_reloading = false
	if magazine_amount < 0:
		magazine_amount = 0


func reload_progress():
	if is_reloading:
		reload_bar.visible = true
		reload_bar.value = reload_timer
	else:
		reload_bar.visible = false
		

func new_weapon(weapon_selected: int):
	var debug_menu = get_parent().get_parent().get_node("DebugMenu")
	current_weapon = all_guns[weapon_selected]
	equip_weapon(current_weapon)
	
	if player_ID == 0:
		debug_menu.update_inventory_display_1(get_parent().inventory)
	else:
		debug_menu.update_inventory_display_2(get_parent().inventory)
		
		
		
func visuell_recoil_tween():
	var recoil_tween = self.create_tween()
	recoil_tween.tween_property(gunsprite_2d, "position",Vector2(visuell_recoil,0),0.05).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	recoil_tween.tween_property(gunsprite_2d, "position",Vector2(22,-1),0.07).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
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
