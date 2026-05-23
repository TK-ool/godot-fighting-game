class_name BulletBehaviour
extends Resource

# What happens to the bullet on Player hit
func on_hit(bullet: Node2D):
	pass

# What happens to the Bullet on Wall Hit
func on_wall_hit(bullet: Node2D):
	pass

# What happens to the Bullet each tick
func on_tick(bullet: Node, delta: float):
	pass

func on_ready(bullet: Node):
	pass
