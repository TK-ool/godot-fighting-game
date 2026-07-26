class_name Player
extends CharacterBody2D


signal device_id(player_id:int)
signal player_respawn (player_name: String)
signal player_died(player_name: String)

@onready var gun: Gun = $Gun
@onready var sprite_2d: Sprite2D = $Sprite2D

#Audio
@onready var movement_sounds: AudioStreamPlayer = $Movement_sounds


const SPEED = 400.0
const JUMP_VELOCITY = -800.0
var is_jumping: bool = false # wert wird für knockbackjump benutzt
var gravity: float = 1700
const normal_gravity: float = 1700
var final_gravity:float
var gravity_multiplier: float = 1.0
var jump_multiplier: float = 1.0

# acceleration wie schnell die höchstgeschwindigkeit erreicht wird
var acceleration: float = 12		# beide starten und stoppen noch komisch und das verlangsamt die bewegung muss man noch testen auch mit sprites später
# friction beim anhalten hochstellen für schnellstopp
var deceleration: float = 15

#Knockback Values
var knockback: Vector2 = Vector2.ZERO
var knockback_duration: float = 0.0
var is_knocked_back: bool = false

#jumpbuffers
var jumpbuffer: float = 0.0
const jumpbuffer_max_time: float = 0.12
var jump_cooldown: float 
const JUMP_COOLDOWN_TIMER: float = 0.19 # wird für wandsprung benötigt um den nicht zu chainen +sounds + damit nicht doublejump chain into walljump geht 

#doublejump
var jumps_left : int = 0
const max_jumps: int = 1
var unlimited_jumps: bool = false
var is_in_the_air: bool = false

#Dash values
const Dashspeed = 1200
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.RIGHT
var dash_cooldown: float 
const DASH_COOLDOWN_TIME: float = 0.3 # zum setzten
var dash_timer: float = 0.0 #derzeitiger Dash
const DASH_TIME: float = 0.2 #Dashtime zums setzten
var airdash: bool = false

#Walljump values
const gravity_wall: float = 80
const wall_jump_push_force: float = 1200
#coyote time ist zeit nachdem der spieler die Wand verlassen hat, das er den wandspung noch ausführen kann
var wall_contact_coyote: float = 0.0
const wall_contact_coyote_time: float = 0.02
#lock horizontal movement zeit
var wall_jump_lock:float = 0.0
const Wall_jump_locktime: float = 0.1
var look_direction_x: int = 1

#for sprite squash
var air_timer: float = 0.0
var air_sprite: bool = false

#flash effect on hit
@onready var hitflash: AnimationPlayer = $Hitflash

@export var health_data: HealthResource
var device : int
var deadzone : float = 0.2

var inventory: Inventory = Inventory.new()

func _physics_process(delta: float) -> void:
	
	gravity_var(delta)
	overall_movement(delta)
	move_and_slide()
	dash(delta)
	jumps(delta)
	knocked_back()
	drop_down()
	scaling(delta)

	
func _ready() -> void:
	device_id.emit(device)
	health_data = health_data.duplicate()
	health_data.died.connect(died_)
	add_to_group("Player_%d" % device)
	add_to_group("Players")# alle spieler für camera/ und mehr als 2
	
	
func gravity_var(delta): # um im fall die gravity zu erhöhen
	final_gravity = normal_gravity * gravity_multiplier
	if is_on_floor() or is_on_wall():
		gravity = lerp(gravity, final_gravity, 20 * delta)
	elif velocity.y >= 0:
		gravity = lerp(gravity, final_gravity * 1.40, 1 * delta) # max gravity wert beim fallen
		
func overall_movement(delta):
		if knockback_duration <= 0.0:
			if is_dashing == false:
				# normales movement
				var direction := Input.get_axis("P%d_links" % device,"P%d_rechts" % device)
				var movement_weight: float = delta * (acceleration if direction else deceleration)
				
				if wall_jump_lock > 0.0:
					wall_jump_lock -= delta
					velocity.x = move_toward(velocity.x, 0, SPEED *  0.3) # geschwindigkeit bei dem das movement wiederaufgenommen wird
					
				if direction :
					velocity.x = lerp(velocity.x,direction * SPEED, movement_weight)
					# alter code velocity.x = direction * SPEED
				
				else:
					velocity.x = lerp(velocity.x, 0.0, movement_weight)
					# alter code velocity.x = move_toward(velocity.x, 0, SPEED)
					
			#Walljump, stored die richtung des walljumps und ohne velocity > 0
			if velocity.x != 0 and is_on_wall()  and !is_on_floor():
				look_direction_x = sign(velocity.x)
				wall_contact_coyote = wall_contact_coyote_time
				
				#velocity.y  muss >0 sein sonst würde er vor dem slide die gravity hinzufügen, deswegn doppeltes if
			if !is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x != 0:
				velocity.y = gravity_wall
			
				# normale Gravity funktion, drüber ist die  wallslide gravity
			elif not is_on_floor() and is_dashing == false:
				velocity.y += gravity * gravity_multiplier * delta
				if wall_contact_coyote >= 0:
					wall_contact_coyote -= delta
		elif is_jumping == true: #jump während knockback
				velocity = knockback + Vector2(0, JUMP_VELOCITY)
				knockback_duration -= delta
		else: # nur knockback
			velocity = knockback
			knockback_duration -= delta
				
	
func dash(delta: float) -> void:
	
	var input_direction: Vector2 = Vector2(
		Input.get_axis("P%d_links" % device,"P%d_rechts" % device),
		Input.get_axis("P%d_oben" % device, "P%d_unten" % device)
	).normalized() #normalize X and Y values können nicht weniger als -1 pder mehr als +1 sein
	
	#letzte richtung wird gespeichert
	if input_direction.x != 0:
		dash_direction.x = input_direction.x
		
	if Input.is_action_just_pressed("P%d_dash" % device) and can_dash == true and !is_on_floor():
		airdash = true
	
	if Input.is_action_just_pressed("P%d_dash" % device) and can_dash == true:
		var final_dash_direction: Vector2 = dash_direction
		if input_direction.y != 0 and input_direction.x == 0: # damit bei oben, unten dash kein horizontaler movement dazukomment da Input direktion für richtung über oder unter 0 gespeichert wird
			final_dash_direction.x = 0
		final_dash_direction.y = input_direction.y
		update_audio_player("dash")
		
		can_dash = false
		is_dashing = true
		dash_cooldown = DASH_COOLDOWN_TIME #damit an der wand nicht unlimited gedashed werden kann
		dash_timer = DASH_TIME
		
		velocity = final_dash_direction * Dashspeed
	if dash_cooldown >0:
		dash_cooldown -= delta
		
	if is_dashing:
		dash_timer -= delta
		
		if dash_timer <= 0.0:
			is_dashing = false
			airdash = false
			velocity = input_direction
		
	if (is_on_floor() or is_on_wall()) and dash_cooldown <= 0:
		can_dash = true
		
	if airdash == true and is_on_floor() or is_on_wall() or is_on_ceiling():
		is_dashing = false
		airdash = false
		

func jumps(delta):
	var final_jump_height = JUMP_VELOCITY * jump_multiplier
	
	if Input.is_action_just_pressed("P%d_jump" % device):
		jumpbuffer = jumpbuffer_max_time
		
	if jumpbuffer >0:
		jumpbuffer -= delta
		
	if jump_cooldown >0:
		jump_cooldown -= delta
		
	if is_on_floor() or is_on_wall():
		is_jumping = false
		is_in_the_air = false
		jumps_left = max_jumps
	else:
		is_in_the_air = true
	#doublejump
	if is_in_the_air and Input.is_action_just_pressed("P%d_jump" % device) and jumps_left > 0 and jump_cooldown <= 0:
		is_jumping = true
		jump_cooldown = JUMP_COOLDOWN_TIMER
		update_audio_player("jump")
		velocity.y =  final_jump_height
		sprite_2d.scale =  Vector2(0.3,0.6)
		if unlimited_jumps == false:
			jumps_left -= 1
		
	if !is_dashing and (is_on_floor() or wall_contact_coyote > 0.0) and jump_cooldown <= 0 and jumpbuffer >0:
		
		is_jumping = true
		update_audio_player("jump")
		#squish for jump
		sprite_2d.scale =  Vector2(0.3,0.6)
		jumpbuffer = 0.0
		
		#walljump
		if wall_contact_coyote > 0.0:
			velocity.x = -look_direction_x * wall_jump_push_force
			velocity.y =  final_jump_height * 1.2
			wall_jump_lock = Wall_jump_locktime
			jump_cooldown = JUMP_COOLDOWN_TIMER # damit sound und squish bei spam nicht bugged
		else:
			#normal jump
			velocity.y =  final_jump_height
			
			
			
				
	# variable jumphöhe / verträgt sich aber nicht so gut mit walljump und jumpbuffer maybe anpassen oder entfernen
	elif  Input.is_action_just_released("P%d_jump" % device) and velocity.y <= -0 and !is_dashing:
			is_jumping = false
			velocity.y = velocity.y / 2

func _on_hit_area_area_entered(bullet: Node2D) -> void:
	if !bullet.is_in_group("Player_%d" % device) and bullet.is_in_group("bullet") and !is_dashing: # dashing für invincibility testweise
		health_data.take_damage(bullet.damage)
		hitflash.play("Hit_flash")
		print(device, "got hit")
		bullet.get_parent().queue_free()
		
func died_():
	if self.is_in_group("Player_0"):
		Global.Round_points_P2 += 1
		if Global.Round_points_P2 >= 2:
			Global.Score_P2 += 1
		player_died.emit()
		#player_respawn.emit()
		
	if self.is_in_group("Player_1"):
		Global.Round_points_P1 += 1
		if Global.Round_points_P1 >= 2:
			Global.Score_P1 += 1
		player_died.emit()
		#player_respawn.emit()
		
		
	self.queue_free()
	
func get_dmg(damage:int): # function wird derzeit nur von Hazard Spikes benutzt // bullet dmg in on area entered
	if is_knocked_back == false and !is_dashing:   # derzeit doppel invinicibilty mit dem on area entert dadrüber // noch nicht sicher ob man komplett unbesiegbar dabei sein soll       /////////////////////////////////////////////////////////////////////////////////
		health_data.take_damage(damage)
		hitflash.play("Hit_flash")
	
	
func apply_knockback(knockback_direction: Vector2, knockback_force:int, knockback_time: float):
	if is_knocked_back == false:
		knockback = knockback_force * knockback_direction
		knockback_duration = knockback_time
		
func knocked_back(): # um doppel knockback bei 2 überlappenden hazards zu verhindern
	if knockback_duration > 0:
		is_knocked_back = true
	else:
		is_knocked_back = false
		
func drop_down(): # setzt es noch für beide spieler 
	if Input.is_action_just_pressed("P%d_drop_down" % device):
		set_collision_mask_value(7, false)
	elif Input.is_action_just_released("P%d_drop_down" % device):
		set_collision_mask_value(7, true)
		
func scaling(delta):
	sprite_2d.scale.x = move_toward(sprite_2d.scale.x,0.433, 0.01)
	sprite_2d.scale.y = move_toward(sprite_2d.scale.y,0.398, 0.01)
	if is_knocked_back: #damit der squash nicht bei einem knockback am boden kommt
		air_timer = 0.1
	if air_timer >0:
		air_timer -= delta
	if !is_on_floor() and air_timer <= 0:
		air_sprite = true
	if air_sprite == true and is_on_floor():
		sprite_2d.scale = Vector2(0.6,0.28)
		air_sprite = false
		

func add_card(new_item: int):
	var new_card = gun.all_guns[new_item] # von gun genommen um alles in einem script zu haben // und um debug menu und items/weapons zu trennen
	inventory.add_card(new_card)
	update_cards()

func update_cards(): # update the card HUD
	var hud = get_parent().get_node("HUD/Score")
	hud.update_cards(device, inventory)


#checks inventory for cards and uses card
func use_card(weapon: WeaponResource):
	if inventory.cards.has(weapon):
		inventory.remove_card(weapon)
		gun.equip_weapon(weapon)
		update_cards()

#Input function for weapon selection
func _input(_event: InputEvent) -> void:
	var hud = get_parent().get_node("HUD/Score")
	
	if Input.is_action_just_pressed("P%d_Weapon_1" % device):
		if inventory.cards.size() >= 1:
			use_card(inventory.cards[0])
	if Input.is_action_just_pressed("P%d_Weapon_2" % device):
		if inventory.cards.size() >= 2:
			use_card(inventory.cards[1])
	if Input.is_action_just_pressed("P%d_Weapon_3" % device):
		if inventory.cards.size() >= 3:
			use_card(inventory.cards[2])
	if Input.is_action_just_pressed("P%d_Weapon_4" % device):
		if inventory.cards.size() >= 4:
			use_card(inventory.cards[3])
			
	if Input.is_action_just_pressed("P%d_card_UI" % device):
		hud.open_card_inv(device)
	if Input.is_action_just_released("P%d_card_UI" % device):
		hud.close_card_inv(device)
	
	
func _on_death_off_screen_screen_exited() -> void:
	died_()


func Knockback_other_player(body: Node2D) -> void:  #knockback on player touch
	var knockback_force_enemy := 500
	var knockback_time_enemy :float = 0.10
	var knockback_direction_enemy: Vector2 = Vector2.ZERO

	if body is Player and !is_in_group("Player_%d" %body.device):
		knockback_direction_enemy = (body.global_position - self.global_position).normalized() #self.global_position.direction_to(body.global_position) // auch eine möglichkeit
		body.apply_knockback(knockback_direction_enemy,knockback_force_enemy,knockback_time_enemy)
		
func update_audio_player(audio_name:String):
	#if audio_name == "none": # wird derzeit nicht benutzt
		#movement_sounds.stop()
	if audio_name:
		movement_sounds["parameters/switch_to_clip"] = audio_name
		movement_sounds.play()
		
