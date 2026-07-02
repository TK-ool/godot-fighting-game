extends RayCast2D

@export var beam_speed: int = 2500
@export var start_distance : int = 5
@export var growth_time: float = 0.1 # wie schnell der laser an breite gewinnt
@export var max_beam_length: float = 2000
@onready var line_2d: Line2D = $Line2D
@onready var line_width = line_2d.width
@export var color: Color = Color.WHITE: set = set_color
@export var is_casting: bool = false: set = casting

@export var Laser_timer: float = 5.0

@export var Laser_rest_timer:float = 1.0

var beam_tween: Tween = null

@export var beam_damage: int = 3
@export var dmg_intervall_time: float = 0.4
var timer_dic: Dictionary = {} # um timer dem spieler zuzuordnen

@onready var casting_particles: GPUParticles2D = $casting_particles
@onready var beam_particles: GPUParticles2D = $beam_particles
@onready var collision_particles: GPUParticles2D = $collision_particles

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_casting = false
	casting(is_casting)
	set_color(color)
	line_2d.points[0] = Vector2.RIGHT * start_distance
	line_2d.points[1] = Vector2.ZERO
	casting_particles.position = line_2d.points[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	# laser position über zeit
	target_position.x = move_toward(target_position.x, max_beam_length, beam_speed * delta)

	var laser_end_position := target_position
	force_raycast_update() ## maybe deativieren für statische
	
	if is_colliding():
		laser_end_position = to_local(get_collision_point()) # convertiert den collision point local zum laser
		
		collision_particles.global_rotation = get_collision_normal().angle()
		collision_particles.position = laser_end_position
		line_2d.points[1] = laser_end_position
		target_position = laser_end_position
	else:
		line_2d.points[1].x = target_position.x
		
	var laser_start_position = line_2d.points[0]
	beam_particles.position = laser_start_position + (laser_end_position - laser_start_position) * 0.5
	beam_particles.process_material.emission_box_extents.x = laser_end_position.distance_to(laser_start_position) * 0.5
	
	
	collision_shape_2d.position = laser_start_position + (laser_end_position - laser_start_position) * 0.5
	collision_shape_2d.shape.set_size(Vector2(laser_end_position.distance_to(laser_start_position), line_width))

	
	
	
		
	collision_particles.emitting = is_colliding()

func casting (new_value: bool) -> void:
	if is_casting == new_value:
		return
	is_casting = new_value
	set_physics_process(is_casting) # wenn casting true ist wird physicsprocess erst gestartet
	
	if beam_particles == null:
		return

	beam_particles.emitting = is_casting
	casting_particles.emitting = is_casting

	if line_2d != null:

		if is_casting == false:
			target_position.x = 0.0
			collision_particles.emitting = false
			collision_shape_2d.disabled = true
			collision_shape_2d.shape.set_size(line_2d.points[0])
			collision_shape_2d.position = line_2d.points[0]
			disappear()
		else:
			var laser_start := Vector2.RIGHT * start_distance
			line_2d.points[0] = laser_start
			line_2d.points[1] = laser_start
			casting_particles.position = laser_start
			collision_shape_2d.disabled = false
			appear()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("leftclick"):
		is_casting = true
	if Input.is_action_just_released("leftclick"):
		is_casting = false
		
func set_color(new_color: Color) -> void:
	color = new_color
	if line_2d == null:
		return
		
	line_2d.modulate = new_color
	casting_particles.modulate = new_color
	collision_particles.modulate = new_color
	beam_particles.modulate = new_color
	
func appear():
	line_2d.visible = true
	if beam_tween and beam_tween.is_running():
		beam_tween.kill()
	beam_tween = create_tween()
	beam_tween.tween_property(line_2d, "width", line_width, growth_time).from(0.0)
	
func disappear():
	if beam_tween and beam_tween.is_running():
		beam_tween.kill()
	beam_tween = create_tween()
	beam_tween.tween_property(line_2d, "width", 0.0 , growth_time).from_current()
	await beam_tween.finished
	line_2d.visible = false
	line_2d.points[1] = Vector2.ZERO
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.get_dmg(beam_damage)
		
		#create new timer for each player that enters
		var dmg_timer = Timer.new()
		dmg_timer.wait_time = dmg_intervall_time
		dmg_timer.timeout.connect(timer_timeout_dmg.bind(body)) # fürs übertragen des body auf die timeout funktion bind()
		add_child(dmg_timer)
		timer_dic[body] = dmg_timer # fügt den timer mit body zum dictonary hinzu fürs nachverfolgen und zugreifen   /// Add "body" as a key and assign dmg_timer as its value. von den DOCS
		dmg_timer.start()
		
		
func timer_timeout_dmg(body: Node2D):
		body.get_dmg(beam_damage)


func _on_area_2d_body_exited(body: Node2D) -> void:
	#löschen des timers der zu dem body gehört
	if timer_dic.has(body):
		var timer = timer_dic[body]
		timer.queue_free()
