extends Node


signal died
signal hit

@export var max_health: int = 100
@export var current_health: int = 100

#This handles the Health Data for a player
func _init() -> void:
	current_health = max_health

func set_health(value):
	current_health = value
	if current_health <= 0:
		died.emit()

func take_damage(amount: float):
	set_health(current_health-amount)
	print(current_health)
	hit.emit()
