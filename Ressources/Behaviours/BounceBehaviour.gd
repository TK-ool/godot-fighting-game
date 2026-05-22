class_name BounceBeahviour
extends BulletBehaviour

@export var bullet_bounces: int = 3
@export var bullet_speed: float = 200.0

func on_wall_hit(bullet: Area2D):
	
	if bullet_bounces <= 0:
		bullet.queue_free()
	return true
