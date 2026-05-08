class_name BulletBehaviour
extends Resource

# What happens to the bullet on Player hit
func on_hit(bullet: Area2D):
	pass

# What happens to the Bullet on Wall Hit
func on_wall_hit(bullet: Area2D):
	pass

# What happens to the Bullet each tick
func on_tick(bullet: Node, delta: float):
	pass
