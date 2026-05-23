extends Node2D

@onready var bullet: Area2D = $Bullet_area
@onready var bullet_col: CharacterBody2D = $"."


var behaviours: Array = []

var speed: float = 600
var size: float = 1.0
var damage: int = 1

var direction :Vector2 = Vector2.ZERO

var device: int


func _ready() -> void:
	bullet.add_to_group("bullet")
	bullet.add_to_group("Player_%d" % device)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	
	if behaviours:
		for b in behaviours:
			b.on_tick(self, delta)
	else:
		bullet_col.velocity = Vector2(speed, 0).rotated(global_rotation)
		bullet_col.move_and_collide(bullet_col.velocity * delta)



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		var hit_behaviour = false
		for b in behaviours:
			b.on_wall_hit(bullet_col)
			hit_behaviour = true
		if not hit_behaviour:
			queue_free()
		
#func set_group():
	#bullet.add_to_group("bullet")
	#bullet.add_to_group("Player_%d" % device)
