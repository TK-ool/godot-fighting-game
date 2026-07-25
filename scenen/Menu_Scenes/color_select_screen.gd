extends Node2D


@onready var start_label: Label = $Start_Label

var player_1_selected: bool = false
var player_2_selected: bool = false

func _ready() -> void:
	for i in get_children():
		if i is Cursor:
			i.connect("player_selected_color", player_selection)
			i.connect("player_deselected_color", player_deselection)


func _process(_delta: float) -> void:
	if player_1_selected and player_2_selected:
		start_label.visible = true
		if Input.is_action_just_pressed("Pause Menu"):
			ScreenTransition.transition()
			await ScreenTransition.on_transition_finished
			Global.random_level()
	else:
		start_label.visible = false
	
func player_selection(device: int):
	print("player %d " %device + "selected his color")
	if device == 0:
		player_1_selected = true
	if device == 1:
		player_2_selected = true
		
func player_deselection(device: int):
	print("player %d " %device + "deselected his color")
	if device == 0:
		player_1_selected = false
	if device == 1:
		player_2_selected = false
