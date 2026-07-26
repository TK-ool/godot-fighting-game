extends Node2D


@onready var start_label: Label = $Start_Label

var player_1_selected: bool = false
var player_2_selected: bool = false

func _ready() -> void:
	install_colorrecs(self)
	


func _process(_delta: float) -> void:
	#wenn beide spieler gewählt haben kann das spiel gestartet werden
	if player_1_selected and player_2_selected:
		start_label.visible = true
		if Input.is_action_just_pressed("Pause Menu"):
			ScreenTransition.transition()
			await ScreenTransition.on_transition_finished
			Global.random_level()
	else:
		start_label.visible = false
	
func player_selection(device: int) -> void:
	print("player %d " %device + "selected his color")
	if device == 0:
		player_1_selected = true
	if device == 1:
		player_2_selected = true
		

# um das signal von den Colorrecs zu bekommen das diese ausgewählt wurden
func install_colorrecs(node: Node) -> void:
	for i in node.get_children():
		if i.is_in_group("Color"):
			i.connect("player_selected_color", player_selection)
		install_colorrecs(i)
