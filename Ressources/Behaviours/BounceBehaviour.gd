class_name BounceBeahviour
extends BulletBehaviour

@export var dict = {bullet_bounces = 3}
var duplicate = dict.duplicate(true)

func on_tick(bullet: Node, delta: float):
	var collision = bullet.move_and_collide(bullet.velocity * delta)
	if collision:
		var reflect =collision.get_remainder().bounce(collision.get_normal())
		bullet.velocity = bullet.velocity.bounce(collision.get_normal())
		bullet.move_and_collide(reflect)
		duplicate["bullet_bounces"] -= 1
	if duplicate["bullet_bounces"] == 0:
		bullet.queue_free()

	
func on_ready(bullet: Node):
	bullet.velocity = Vector2(bullet.speed, 0).rotated(bullet.global_rotation)
