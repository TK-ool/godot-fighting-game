extends Area2D


@onready var Main_bullet_body: CharacterBody2D = $".."

var damage: int = 1

func _ready() -> void:
	damage = Main_bullet_body.damage
