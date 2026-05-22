class_name SplitBehaviour
extends BulletBehaviour

@export var sub_bullet_count: int = 15
@export var sub_bullet_speed: float = 200.0

func on_wall_hit(bullet: Node2D):
	for i in sub_bullet_count:
		var angle = (TAU / sub_bullet_count) * i
		var direction = Vector2.from_angle(angle)
		var b = bullet.duplicate()
		b.position = bullet.position + direction * 20.0
		b.rotation = angle
		#b.speed = sub_bullet_speed
		#b.behaviours = [] # Keine Rekursion
		bullet.get_parent().add_child.call_deferred(b)
	bullet.queue_free()
	return true

		
func on_tick(bullet: Node, delta: float):
	bullet.velocity = Vector2(bullet.speed, 0).rotated(bullet.global_rotation)
	bullet.move_and_collide(bullet.velocity * delta)
