class_name ShurikenBehaviour
extends BulletBehaviour

@export var shuriken_amount : int = 3
@export_range(0, 360, 0.1, "radians_as_degrees") var arc : float = 210

func on_tick(bullet: Node, delta: float):
	
	
	if dictionary[bullet].stuck == false:
		bullet.rotation -= 1
		var collision = bullet.move_and_collide(bullet.velocity * delta)
		if collision:
			var collision_normal = collision.get_normal()
			bullet.velocity = Vector2(0,0)
			bullet.position = bullet.position + collision_normal *  - 10
			dictionary[bullet].stuck = true

	
func on_ready(bullet: Node):
	dictionary[bullet] = {} # erstellen vom dictionary
	dictionary[bullet]["stuck"] = false # erstellen der variable im dictionary
	bullet.velocity = Vector2(bullet.speed, 0).rotated(bullet.global_rotation)
