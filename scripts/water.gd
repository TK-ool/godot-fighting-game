extends Node2D

@onready var area_2d: Area2D = $Area2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.unlimited_jumps = true
		body.jumps_left = 1
		body.gravity_multiplier = 0.08
		body.jump_multiplier = 0.7
		body.velocity.y = body.velocity.y /4
		
	if body.is_in_group("bullet"):
		if body.behaviours:
			body.velocity = body.velocity / 2
			body.speed = body.speed / 2
		else:
			body.speed = body.speed / 2

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		body.unlimited_jumps = false
		body.gravity_multiplier = 1.0
		body.jump_multiplier = 1.0
		body.gravity = body.normal_gravity
	
	if body.is_in_group("bullet"):
		if body.behaviours:
			body.velocity = body.velocity * 2
			body.speed = body.speed * 2
		else:
			body.speed = body.speed * 2
