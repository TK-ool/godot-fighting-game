class_name BounceBeahviour
extends BulletBehaviour




func on_tick(bullet: Node, delta: float):
	var collision = bullet.move_and_collide(bullet.velocity * delta)
	if collision:
		var reflect =collision.get_remainder().bounce(collision.get_normal())
		bullet.velocity = bullet.velocity.bounce(collision.get_normal())
		bullet.move_and_collide(reflect)
		dictionary[bullet].bullet_bounces -=1
	if dictionary[bullet].bullet_bounces == 0:
		bullet.queue_free()

	
func on_ready(bullet: Node):
	dictionary[bullet] = {} # erstellen vom dictionary
	dictionary[bullet]["bullet_bounces"] = 5 # erstellen der variable im dictionary
	bullet.velocity = Vector2(bullet.speed, 0).rotated(bullet.global_rotation)
