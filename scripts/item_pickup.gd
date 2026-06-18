extends Node2D

@export_enum("No Gun:0", "Handgun:1", "splitgun:2", "shuriken:3", "Machine Gun:4", "Bouncegun:5") var item_to_pickup: int # abhängig vom array in gunhandler
@export var gun_texture : Texture2D
@onready var item: Sprite2D = $Area2D/Item
@onready var area_2d: Area2D = $Area2D
@onready var respawn_timer: Timer = $Respawn_Timer
var picked_up: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item.texture = gun_texture
	tween()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if picked_up == true:
		area_2d.monitoring = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.add_card(item_to_pickup)
		item.visible = false
		respawn_timer.start()
		picked_up = true
		
		
func tween():
	var up_down_tween = self.create_tween().set_loops()
	up_down_tween.tween_property(area_2d,"position",Vector2(0,10),1.1).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	up_down_tween.tween_property(area_2d,"position",Vector2(0,-10),1.1).as_relative().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_respawn_timer_timeout() -> void:
	picked_up = false
	area_2d.monitoring = true
	item.visible = true
