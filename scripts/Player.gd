extends CharacterBody2D


signal device_id(player_id:int)
signal player_respawn (player_name: String)

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

#Dash values
const Dashspeed = 1200
var is_dashing: bool = false
var can_dash: bool = true
var dash_direction: Vector2 = Vector2.RIGHT
var dash_timer: float = 0.0
var DASH_TIME: float = 0.2
var airdash: bool = false

#Walljump values
const gravity_wall: float = 80
const wall_jump_push_force: float = 800
#coyote time ist zeit nachdem der spieler die Wand verlassen hat, das er den wandspung noch ausführen kann
var wall_contact_coyote: float = 0.0
const wall_contact_coyote_time: float = 0.02
#lock horizontal movement zeit
var wall_jump_lock:float = 0.0
const Wall_jump_locktime: float = 0.2
var look_direction_x: int = 1


@export var health_data: HealthResource
var device : int
var deadzone : float = 0.2


func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	

	if is_dashing == false:
		
		var direction := Input.get_axis("P%d_links" % device,"P%d_rechts" % device)
		
		
		if wall_jump_lock > 0.0:
			wall_jump_lock -= delta
			velocity.x = move_toward(velocity.x, 0, SPEED *  0.3) # geschwindigkeit bei dem das movement wiederaufgenommen wird
			
		elif direction :
			velocity.x = direction * SPEED
		
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
	#Walljump, stored die richtung des walljumps und ohne velocity > 0
	if velocity.x != 0 and is_on_wall()  and !is_on_floor():
		look_direction_x = sign(velocity.x)
		wall_contact_coyote = wall_contact_coyote_time
		
		#velocity.y  muss >0 sein sonst würde er vor dem slide die gravity hinzufügen, deswegn doppeltes if
	if !is_on_floor() and velocity.y > 0 and is_on_wall() and velocity.x != 0:
		velocity.y = gravity_wall
	
		# normale Gravity funktion drüber wallslide gravity
	elif not is_on_floor() and is_dashing == false:
		velocity += get_gravity() * delta
		wall_contact_coyote -= delta

		
	move_and_slide()
	dash(delta)
	jumps()
	
func _ready() -> void:
	device_id.emit(device)
	health_data = health_data.duplicate()
	health_data.died.connect(died_)
	add_to_group("Player_%d" % device)
	
	
	
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
		
		can_dash = false
		is_dashing = true
		dash_timer = DASH_TIME
		
		velocity = final_dash_direction * Dashspeed
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			airdash = false
			velocity = input_direction
		
	if is_on_floor() or is_on_wall():
		can_dash = true
		
	if airdash == true and is_on_floor() or is_on_wall() or is_on_ceiling():
		is_dashing = false
		airdash = false
		

func jumps():
	if !is_dashing and (is_on_floor() or wall_contact_coyote > 0.0):
		if Input.is_action_just_pressed("P%d_jump" % device):
			velocity.y = JUMP_VELOCITY
			if wall_contact_coyote > 0.0:
				velocity.x = -look_direction_x * wall_jump_push_force
				velocity.y = JUMP_VELOCITY * 1.2
				wall_jump_lock = Wall_jump_locktime

func _on_hit_area_area_entered(bullet: Area2D) -> void:
	
	if !bullet.is_in_group("Player_%d" % device) and bullet.is_in_group("bullet"):
		health_data.take_damage(bullet.damage)
		for b in bullet.behaviours:
			b.on_hit(bullet)
		print(device, " got hit")
		bullet.queue_free()
		
func died_():
	if self.is_in_group("Player_0"):
		Global.Score_P2 += 1
		player_respawn.emit()
		
	if self.is_in_group("Player_1"):
		Global.Score_P1 += 1
		player_respawn.emit()
		
		
	self.queue_free()
