extends Node2D
class_name Spring


# current spring velocity
var velocity: float  = 0
# force applied to spring
var force: float =  0
#current height of the spring
var height: int  = 0
#normal sping height
var target_height: int

@onready var timer: Timer = $Timer

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var index = 0
#how much an object movement will affect the spring

var motion_factor = 0.012

signal splash
# last object collided with
var collided_with = null

func initialize(x_position, id) -> void:
	sprite_2d.visible = false
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = id

func water_update(spring_constant, dampening):
	#hooke´s law force function  Die Formel zur Berechnung der Federkraft lautet: F = -k ⋅ x
	
	#update position
	height = position.y
	
	#spring current extension
	var x = height - target_height
	
	var loss: float = -dampening * velocity
	
	#hooke´s law
	force = -spring_constant * x +loss
	
	#apply force
	velocity += force
	
	# move the spring
	position.y += velocity
	###print(loss)   angucken ob man die werte schneller sinken lassen kann auf 0
	
func set_collision_width(value):
	# set the collision shape size of the springs
	collision_shape_2d.shape.size = Vector2(value, collision_shape_2d.shape.size.y)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == collided_with:
		
		return
		
	else:
		collided_with = body
		timer.start()
		var speed = body.velocity.y * motion_factor
		splash.emit(index, speed)
	


func _on_timer_timeout() -> void:
	collided_with = null
