class_name BulletBehaviour
extends Resource

# um Variablen für bullets zu benutzen
var dictionary: Dictionary

# What happens to the bullet on Player hit
func on_hit(_bullet: Node2D):
	pass

# What happens to the Bullet on Wall Hit
func on_wall_hit(_bullet: Node2D):
	pass

# What happens to the Bullet each tick
func on_tick(_bullet: Node, _delta: float):
	pass

func on_ready(_bullet: Node):
	pass
