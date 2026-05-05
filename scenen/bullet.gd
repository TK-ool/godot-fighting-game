extends Node2D


const Speed: int = 600

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * Speed * delta
