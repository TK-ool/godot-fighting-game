extends Resource
class_name HealthResource

signal died
signal hit
var dead:= false

@export var max_health: int = 10
@export var current_health: int = 10

#This handles the Health Data for a player
func _init() -> void:
	dead = false
	current_health = max_health

func set_health(value):
	current_health = value

	if current_health <= 0 and !dead:
		dead = true
		died.emit()

func take_damage(amount: float):
	set_health(current_health-amount)
	print(current_health)
	hit.emit()
	
