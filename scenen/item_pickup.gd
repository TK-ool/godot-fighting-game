extends Node2D

@export_enum("Bouncegun:0", "Handgun:1", "splitgun:2") var item_to_pickup: int
@export var gun_texture : Texture2D
@onready var sprite_2d: Sprite2D = $Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = gun_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.gun.new_weapon(item_to_pickup)
		body.update_cards()
		self.queue_free()
