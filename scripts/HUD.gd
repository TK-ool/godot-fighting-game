extends Control
@onready var score_p_1: Label = $Score_P1
@onready var score_p_2: Label = $Score_P2
@onready var health_p_1: TextureProgressBar = $Health_P1
@onready var health_p_2: TextureProgressBar = $Health_P2
@onready var ammo_p_1: Label = $Ammo_P1
@onready var ammo_p_2: Label = $Ammo_P2



var player_1: Player
var player_2: Player

func _process(_delta: float) -> void:
	
	score_p_1.text = "Player 1 kills " + str(Global.Score_P1)
	score_p_2.text = "Player 2 kills " + str(Global.Score_P2)
	health_p_1.value = player_1.health_data.current_health
	health_p_2.value = player_2.health_data.current_health
	ammo_p_1.text = "Ammo : " + str(player_1.gun.bullet_amount) + "/" + str(player_1.gun.magazine_size)
	ammo_p_2.text = "Ammo : " + str(player_2.gun.bullet_amount) + "/" + str(player_2.gun.magazine_size)
func player_1_spawned(new_player: Player):
	player_1 = new_player
	
func player_2_spawned(new_player: Player):
	player_2 = new_player
