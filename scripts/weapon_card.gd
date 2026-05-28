extends Control


@onready var weapon_name: Label = $Panel/VBoxContainer/WeaponName
@onready var weapon_texture: TextureRect = $Panel/VBoxContainer/WeaponTexture


const WEAPON_CARD = preload("res://scenen/weapon_card.tscn")


func setup(weapon: WeaponResource):
	weapon_name.text = weapon.weapon_name
	weapon_texture.texture = weapon.weapon_sprite
	
