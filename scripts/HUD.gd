extends Control
@onready var score_p_1: Label = $Score_P1
@onready var score_p_2: Label = $Score_P2
@onready var health_p_1: TextureProgressBar = $Health_P1
@onready var health_p_2: TextureProgressBar = $Health_P2
@onready var ammo_p_1: Label = $Ammo_P1
@onready var ammo_p_2: Label = $Ammo_P2

@onready var start_timer_label: Label = $Start_timer_label

@onready var level: Node2D = $"../.."

const points_texture = preload("uid://ccylu3vwvew2y")



@onready var point_p_1: TextureRect = $Point_P1
@onready var point_p_2: TextureRect = $Point_P2
@onready var final_point: TextureRect = $Final_point




@onready var card_ui_p_1: Control = $CardUI_P1/CardUI
@onready var card_ui_p_2: Control = $CardUI_P2/CardUI


const WEAPON_CARD = preload("res://scenen/weapon_card.tscn")

var player_1: Player
var player_2: Player

func _ready() -> void:
	start_timer_label.visible = true

func _process(_delta: float) -> void:
	round_points()
	set_player_hud()
	round_starts()
	



func player_1_spawned(new_player: Player):
	player_1 = new_player
	
func player_2_spawned(new_player: Player):
	player_2 = new_player

func update_cards(player_id: int, inventory: Inventory):
	#check player
	if player_id == 0:
		card_ui_p_1.update_display(inventory)
	else:
		card_ui_p_2.update_display(inventory)
		
func open_card_inv(player_id: int):
	if player_id == 0:
		card_ui_p_1.open_inventory()
	else:
		card_ui_p_2.open_inventory()
		
func close_card_inv(player_id: int):
	if player_id == 0:
		card_ui_p_1.close_inventory()
	else:
		card_ui_p_2.close_inventory()
		
func set_player_hud():
	
	if player_1 != null:
		health_p_1.value = player_1.health_data.current_health
		ammo_p_1.text = "Ammo : " + str(player_1.gun.bullet_amount) + "/" + str(player_1.gun.magazine_size)
		score_p_1.text = "Player 1 Points " + str(Global.Score_P1)
	else:
		health_p_1.value = 0
		
	if player_2 != null:
		health_p_2.value = player_2.health_data.current_health
		ammo_p_2.text = "Ammo : " + str(player_2.gun.bullet_amount) + "/" + str(player_2.gun.magazine_size)
		score_p_2.text = "Player 2 Points " + str(Global.Score_P2)
	else: 
		health_p_2.value = 0
		
func round_points():
	if Global.Round_points_P1  >= 1:
		point_p_1.texture = points_texture
	if Global.Round_points_P1 >= 2:
		final_point.texture = points_texture
		
	if Global.Round_points_P2 >= 1:
		point_p_2.texture = points_texture
		point_p_2.modulate = Color("ff0000")
	if Global.Round_points_P2 >= 2:
		final_point.texture = points_texture
		final_point.modulate = Color("ff0000")
		
func round_starts():
	start_timer_label.text = "%d" % level.round_start_timer
	if level.round_start_timer <= 1:
		start_timer_label.text = "GO!"
	if level.round_start_timer <= 0:
		start_timer_label.visible = false
