class_name WeaponResource
extends Resource

@export var weapon_name: String # The name of the Weapon

@export var weapon_sprite: Texture2D # The Sprite of the Weapon on the Character
@export var card_sprite: Texture2D # The Sprite Of the Card in inventory
@export var Bullet_scene: PackedScene # the bullet scene

@export var damage: int # the amount of damage per bulet
@export var fire_rate: float # the fire rate of the weapon
@export var bullet_speed: float # the speed of the bullet
@export var bullet_amount: int # the amount of bullets in the weapon
@export var reload_time: float # the time the reload need

@export var gunpoint_offset_left: Vector2 # Used to set the marker for spawning bullets on guns left
@export var gunpoint_offset_right: Vector2 # Used to set the marker for spawning bullets on guns left

@export var behaviours: Array[BulletBehaviour] = []
