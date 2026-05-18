class_name Hazard
extends Node

@export var damage := 2
@export var knockback_force := 400
@export var knockback_time :float = 0.15
var knockback_direction: Vector2 = Vector2.ZERO



func _on_body_entered(player: Node2D) -> void:
	if player is Player: 
		player.get_dmg(damage)
		knockback_direction = (player.global_position - self.global_position).normalized() #player.global_position.direction_to(self.global_position) // auch eine möglichkeit
		player.apply_knockback(knockback_direction,knockback_force,knockback_time)
		print(knockback_direction)
