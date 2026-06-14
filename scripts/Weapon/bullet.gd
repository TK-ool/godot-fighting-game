extends Node2D

@onready var bullet: Area2D = $Bullet_area
@onready var bullet_col: CharacterBody2D = $"."
@export var bullet_hit : PackedScene

var behaviours: Array = []

var speed: float = 600
var size: float = 1.0
var damage: int = 1

var collision_result: KinematicCollision2D 



var direction :Vector2 = Vector2.ZERO

var device: int


func _ready() -> void:
	bullet_col.add_to_group("bullet") # für queue free nach runden ende
	bullet.add_to_group("bullet") # für hit detect
	bullet.add_to_group("Player_%d" % device)
	if behaviours:
		for b in behaviours:
			b.on_ready(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _physics_process(delta: float) -> void:
	collision_detect()
	

	if behaviours:
		for b in behaviours:
			b.on_tick(self, delta)
	else:
		bullet_col.velocity = Vector2(speed, 0).rotated(global_rotation)
		collision_result = bullet_col.move_and_collide(bullet_col.velocity * delta)
	

	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

func collision_detect():
	if collision_result != null:
		if collision_result.get_collider().name == "TileMapLayer":
			var bullet_smoke = bullet_hit.instantiate() as GPUParticles2D # bullet impact particles
			bullet_smoke.global_position = bullet_col.global_position
			bullet_smoke.rotation =  collision_result.get_normal().angle()
			get_parent().add_child(bullet_smoke)
			var hit_behaviour = false
			for b in behaviours:
				b.on_wall_hit(bullet_col)
				hit_behaviour = true
			if not hit_behaviour:
				queue_free()
		
# gegen move_and_collide ersetzt für besser world hit genauigkeit für partikel
#func _on_body_entered(body: Node2D) -> void:
	#if body is TileMapLayer:
		#var hit_behaviour = false
		#for b in behaviours:
			#b.on_wall_hit(bullet_col)
			#hit_behaviour = true
		#if not hit_behaviour:
			#queue_free()
