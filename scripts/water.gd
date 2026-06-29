extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var springs_visible : bool = false

#spring stiffness bewegt sich schneller oder langsamer
@export var k = 0.1
#spring force loss over time (dampening)
@export var d = 0.10

@export var spread = 0.0015

var springs: Array = []
#how often each frame, for better spread
var passes = 8

@export var distance_between_springs = 32
@export var spring_number = 6

#body of water stats
@export var depth = 400
var target_height = global_position.y
var bottom 
@onready var polygon_2d: Polygon2D = $Polygon2D



#water border
#@onready var water_border: SmoothPath = $Line2D/SmoothPath
#@export var border_thickness = 1.1



const WATER_SPRING = preload("uid://bsy8wy24gqc4c")

func _ready() -> void:
	bottom = target_height + depth
	
	for i in range(spring_number):
		var x_position = distance_between_springs * i
		var w = WATER_SPRING.instantiate()
		
		add_child(w)
		springs.append(w)
		w.initialize(x_position, i)
		w.set_collision_width(distance_between_springs)
		w.connect("splash", splash)
		if springs_visible == true:
			w.sprite_2d.visible = true
		
		
	var total_lenght = distance_between_springs * (spring_number -1)
	var rectangle = RectangleShape2D.new().duplicate()
	var rect_position: Vector2 = Vector2(total_lenght / 2, depth / 2)
	var rect_size : Vector2 = Vector2(total_lenght, depth)
	
	
	# setzten der collision shape
	collision_shape_2d.position = rect_position
	rectangle.set_size(rect_size)
	collision_shape_2d.shape = rectangle
	


			
			
func _physics_process(_delta: float) -> void:
	draw_water_body()
	
	#calls the function in every spring
	for i in springs:
		i.water_update(k,d)
	
	#stores the height difference to the left and right springnode
	var left_deltas: Array = []
	var right_deltas: Array  = []

#setzt die deltas auf 0
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
		
	for j in range(passes):
			#adds velocity to the spring left and right of the current spring
		for i in range(springs.size()):
			if i >0:
				left_deltas[i] = spread * (springs[i].height - springs[-i].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]


# adds speed to a spring index
func splash(index, speed):
	if index >=0 and index < springs.size():
		springs[index].velocity += speed




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.unlimited_jumps = true
		body.jumps_left = 1
		body.gravity_multiplier = 0.1
		body.jump_multiplier = 0.7
		body.velocity.y = body.velocity.y /4
		
	if body.is_in_group("bullet"):
		if body.behaviours:
			body.velocity = body.velocity / 2.5
			body.speed = body.speed / 2.5
		else:
			body.speed = body.speed / 2.5

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.unlimited_jumps = false
		body.gravity_multiplier = 1.0
		body.jump_multiplier = 1.0
		body.gravity = body.normal_gravity
	
	if body.is_in_group("bullet"):
		if body.behaviours:
			body.velocity = body.velocity * 2.5
			body.speed = body.speed * 2.5
		else:
			body.speed = body.speed * 2.5
			
			
func draw_water_body():
	var surface_points = []
	
	#makes a new array with position of the points
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
		
	var first_index = 0
	var last_index = surface_points.size()-1
	
	#water polygon points
	var  water_polygon_points = surface_points
	#add the other two points at the bottom of the waterbody to close the shape
	water_polygon_points.append(Vector2(surface_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(surface_points[first_index].x, bottom))
	
	water_polygon_points = PackedVector2Array(water_polygon_points)
	polygon_2d.set_polygon(water_polygon_points)


	
#func new_border():
	#var curve = Curve2D.new().duplicate()
	
	#var surface_points = []
	
	#for i in range(springs.size()):
		#surface_points.append(springs[i].position)
		
	#for i in range(surface_points.size()):
		#curve.add_point(surface_points[i])
		
	#water_border.curve = curve
	#water_border.smooth(true)
