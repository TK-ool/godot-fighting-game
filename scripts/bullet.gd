extends Node2D


const Speed: int = 600

func _ready():
	add_to_group("bullet")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * Speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()
