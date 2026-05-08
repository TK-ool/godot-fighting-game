extends Control
@onready var score_p_1: Label = $Score_P1
@onready var score_p_2: Label = $Score_P2


func _process(_delta: float) -> void:
	
	score_p_1.text = "Player 1 Score " + str(Global.Score_P1)
	score_p_2.text = "Player 2 Score " + str(Global.Score_P2)
