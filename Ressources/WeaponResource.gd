class_name WeaponResource
extends Resource



@export_group("Card_infos") 

@export var weapon_name: String # The name of the Weapon
@export var card_sprite: Texture2D # The Sprite Of the Card in inventory
@export_multiline var weapon_description : String # weapon_description for the card


@export_group("Setup") 
@export var Bullet_scene: PackedScene # the bullet scene
@export var bullet_casing_scene: PackedScene # Bullet casing scene
@export var weapon_sprite: Texture2D # The Sprite of the Weapon on the Character
@export var gunpoint_offset_left: Vector2 # Used to set the marker for spawning bullets on guns left
@export var gunpoint_offset_right: Vector2 # Used to set the marker for spawning bullets on guns left
@export var casing_eject_point: Vector2 # marker used to spawn eject casings
@export var behaviours: Array[BulletBehaviour] = []


@export_group("Stats") 
@export var damage: int # the amount of damage per bullet
@export var fire_rate: float # the fire rate of the weapon
@export var bullet_speed: float # the speed of the bullet
@export var bullet_spread: float # bullet spread amount
@export var magazine_size : int # the amount of bullets in the weapon
@export var reload_time: float # the time the reload need
@export var multishoot: bool
@export var multishoot_amount: int # how many bullets per shoot
@export_range(0, 360, 0.1, "radians_as_degrees") var multishoot_arc : float = 45
