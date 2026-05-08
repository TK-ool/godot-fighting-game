extends Area2D

@onready var bullet: Area2D = $"."

var behaviours: Array = []

var speed: float = 600
var size: float = 1.0
var damage: int = 1

var device: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		var hit_behaviour = false
		for b in behaviours:
			b.on_wall_hit(bullet)
			hit_behaviour = true
		if not hit_behaviour:
			queue_free()
		
func set_group():
	add_to_group("bullet")
	add_to_group("Player_%d" % device)
