class_name SplitBehaviour
extends BulletBehaviour

@export var sub_bullet_count: int = 10
@export var sub_bullet_speed: float = 200.0
@export_range(0, 360, 0.1, "radians_as_degrees") var arc : float = 170

func on_wall_hit(bullet: Node2D):
	if bullet.collision_result != null:
		var collision_normal = bullet.collision_result.get_normal() # normal zeigt in die gegenüberliegende richtung der wand collision
		for i in sub_bullet_count:
			var direction = collision_normal.angle() # convertiert die normal zu einem winkel
			var b = bullet.duplicate()
			var angle_increment = arc / (sub_bullet_count - 1) #  abstand zwischen den kugeln
			b.position = bullet.position + collision_normal * 3 # collision_normal * 3 damit abstand zur wand ist sonst spawnen die kugeln nicht korrekt bei starkem winkel zur wand
			b.global_rotation = direction + angle_increment * i - arc / 2 #spreaded die kugeln gleichmäßig über den angle
			b.device = bullet.device # sonst defaultet er zu spieler 0
			bullet.get_parent().add_child.call_deferred(b)
		bullet.queue_free()
		return true

		
func on_tick(bullet: Node, delta: float):
	bullet.velocity = Vector2(bullet.speed, 0).rotated(bullet.global_rotation)
	bullet.collision_result = bullet.move_and_collide(bullet.velocity * delta)
