extends Node2D

@export var bullet_type: BulletResource
var speed: int = 600
var size: float = 1.0
var damage: int = 1

func _ready():
	add_to_group("bullet")
	calc_speed_modifier()
	calc_size_modifier()
	calc_damage_modfier()
	calculateAmountModfier()
	calculateSpreadModfier()
	calculateDuratonModfier()

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()


func calc_speed_modifier():
	speed = speed * bullet_type.speed_modifier
	
func calc_size_modifier():
	size = size * bullet_type.size_modifier
	self.scale = Vector2(size, size)
	
func calc_damage_modfier():
	damage = bullet_type.damage_modifier
	
func calculateAmountModfier():
	pass
	
func calculateSpreadModfier():
	pass

func calculateDuratonModfier():
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		queue_free()
