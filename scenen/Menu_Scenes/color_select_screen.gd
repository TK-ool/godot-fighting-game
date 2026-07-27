extends Node2D


@onready var start_label: Label = $Start_Label
@onready var player_1_preview: TextureRect = $Color_section/Player1_preview
@onready var player_2_preview: TextureRect = $Color_section/Player2_preview

var player_1_selected_color: bool = false
var player_2_selected_color: bool = false
var player_1_selected_skin: bool = false
var player_2_selected_skin: bool = false

func _ready() -> void:
	install_colorrecs(self)
	install_skinrecs(self)
	


func _process(_delta: float) -> void:
	#wenn beide spieler gewählt haben kann das spiel gestartet werden
	if player_1_selected_color and player_2_selected_color and player_1_selected_skin and player_2_selected_skin:
		start_label.visible = true
		if Input.is_action_just_pressed("Pause Menu"):
			ScreenTransition.transition()
			await ScreenTransition.on_transition_finished
			Global.random_level()
	else:
		start_label.visible = false
	
func player_selection_color(device: int) -> void:
	print("player %d " %device + "selected his color")
	if device == 0:
		player_1_selected_color = true
	if device == 1:
		player_2_selected_color = true
		
		
	
func player_selection_skin(device: int) -> void:
	print("player %d " %device + "selected his skin")
	if device == 0:
		player_1_selected_skin = true
		player_1_preview.texture = Global.P1_Skin
	if device == 1:
		player_2_selected_skin = true
		player_2_preview.texture = Global.P2_Skin
		

# um das signal von den Colorrecs zu bekommen das diese ausgewählt wurden
func install_colorrecs(node: Node) -> void:
	for i in node.get_children():
		if i.is_in_group("Color"):
			i.connect("player_selected_color", player_selection_color)
		install_colorrecs(i)
		
		
func install_skinrecs(node: Node) -> void:
	for i in node.get_children():
		if i.is_in_group("Skin"):
			i.connect("player_selected_skin", player_selection_skin)
		install_skinrecs(i)
		
