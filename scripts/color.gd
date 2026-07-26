extends ColorRect
# Called when the node enters the scene tree for the first time.
@onready var selected_player_label: Label = $ColorSelected/selected_player_label
@onready var color_selected: Sprite2D = $ColorSelected
@onready var color_sounds: AudioStreamPlayer = $Color_sounds

signal player_selected_color

var player_inside: Dictionary = {}
var player_number: int
var is_selected: bool = false
var player1_selected: bool = false
var player2_selected: bool = false

func _ready() -> void:
	#für auswahl anderer farben desselben spielers connecte ich den Colorrect mit den anderen
	for i in get_parent().get_children():
		if i.is_in_group("Color"):
			i.connect("player_selected_color", reselect_color)
	
	#cursor schickt das signal das er eiuune farbe gewählt hat(in einem colorrect und actionstaste)
	for i in get_parent().get_parent().get_parent().get_children():
		if i is Cursor:
			i.connect("player_clicked_color", select_color)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	#fügt dem dictionary alle spieler in dem colorect hinzu
	player_inside[body.name] = body.device
	
	if is_selected == false:
		if body is Cursor:
			body.is_in_colorrect = true
			body.player_color = self.color
			self.scale = Vector2(1.2,1.2)
			update_audio_player("hover")




func _on_area_2d_body_exited(body: Node2D) -> void:
		#lösch den spieler der den Colorrect verlässt
		player_inside.erase(body.name)
			
		if body is Cursor:
				body.is_in_colorrect = false
				self.scale = Vector2(1.0,1.0)

				
#when selecting another color
func select_color(device: int)-> void:
	#normale auswahl der farbe
	if player_inside.has("Cursor Player 1") and device == 0 and !is_selected:
		is_selected = true
		Global.P1_Color = self.color
		player1_selected = true
		color_selected.visible = true
		player_number = device +1
		selected_player_label.text = "Player %d" %player_number
		self.scale = Vector2(1.0,1.0)
		player_selected_color.emit(device) # schickt signal an den Colorselect screen das ausgewäjlt wurde und an andere Colorrecs das reselected wurde falls notwendig
		update_audio_player("click")
		
	if player_inside.has("Cursor Player 2") and device == 1 and !is_selected:
		is_selected = true
		Global.P2_Color = self.color
		player2_selected = true
		color_selected.visible = true
		player_number = device +1
		selected_player_label.text = "Player %d" %player_number
		self.scale = Vector2(1.0,1.0)
		player_selected_color.emit(device) # schickt signal an den Colorselect screen das ausgewäjlt wurde und an andere Colorrecs das reselected wurde falls notwendig
		update_audio_player("click")
		
		
func reselect_color(device: int) -> void:
	#bei auswahl anderer farben desselben spielers
	if player1_selected and device == 0 and !player_inside.has("Cursor Player 1"):
		is_selected = false
		player1_selected = false
		color_selected.visible = false
		player_number = device +1
		selected_player_label.text = "Player %d" %player_number
		
	if player2_selected and device == 1 and !player_inside.has("Cursor Player 2"):
		is_selected = false
		player2_selected = false
		color_selected.visible = false
		player_number = device +1
		selected_player_label.text = "Player %d" %player_number
		
		
		
func update_audio_player(audio_name:String):
	if audio_name == "none": # wird derzeit nicht benutzt
		color_sounds.stop()
	if audio_name:
		color_sounds.play()
		color_sounds["parameters/switch_to_clip"] = audio_name
		
