class_name BounceBeahviour
extends BulletBehaviour

@export var bullet_bounces: int = 3
@export var bullet_speed: float = 200.0

func on_tick(bullet: Node, delta: float):
	var collision = bullet.move_and_collide(bullet.velocity * delta)
	if collision:
		var reflect =collision.get_remainder().bounce(collision.get_normal())
		bullet.velocity = bullet.velocity.bounce(collision.get_normal())
		bullet.move_and_collide(reflect)



func on_ready(bullet: Node):
	bullet.velocity = Vector2(bullet.speed, 0).rotated(bullet.global_rotation)
