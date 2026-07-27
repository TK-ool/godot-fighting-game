extends TextureRect
# Called when the node enters the scene tree for the first time.
@onready var selected_player_label: Label = $SkinSelected/selected_player_label
@onready var skin_selected: Sprite2D = $SkinSelected
@onready var skin_sounds: AudioStreamPlayer = $Skin_sounds

signal player_selected_skin

var player_inside: Dictionary = {}
var player_number: int
var is_selected: bool = false
var player1_selected: bool = false
var player2_selected: bool = false

func _ready() -> void:
	#für auswahl anderer farben desselben spielers connecte ich den skinrrect mit den anderen
	for i in get_parent().get_children():
		if i.is_in_group("Skin"):
			i.connect("player_selected_skin", reselect_skin)
	
	#cursor schickt das signal das er eiuune farbe gewählt hat(in einem skinrect und actionstaste)
	for i in get_parent().get_parent().get_parent().get_children():
		if i is Cursor:
			i.connect("player_clicked_skin", select_skin)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	#fügt dem dictionary alle spieler in dem skinrect hinzu
	player_inside[body.name] = body.device
	
	if is_selected == false:
		if body is Cursor:
			body.is_in_skinrect = true
			#body.player_color = self.color
			self.scale = Vector2(1.2,1.2)
			update_audio_player("hover")




func _on_area_2d_body_exited(body: Node2D) -> void:
		#lösch den spieler der den Skinrect verlässt
		player_inside.erase(body.name)
			
		if body is Cursor:
				body.is_in_skinrect = false
				self.scale = Vector2(1.0,1.0)

				
#when selecting another Skin
func select_skin(device: int)-> void:
	#normale auswahl der farbe
	if player_inside.has("Cursor Player 1") and device == 0 and !is_selected:
		is_selected = true
		Global.P1_Skin = self.texture
		player1_selected = true
		skin_selected.visible = true
		player_number = device +1
		selected_player_label.text = "Player %d" %player_number
		self.scale = Vector2(1.0,1.0)
		player_selected_skin.emit(device) # schickt signal an den Skinselect screen das ausgewäjlt wurde und an andere Skinrecs das reselected wurde falls notwendig
		update_audio_player("click")
		
	if player_inside.has("Cursor Player 2") and device == 1 and !is_selected:
		is_selected = true
		Global.P2_Skin = self.texture
		player2_selected = true
		skin_selected.visible = true
		player_number = device +1
		selected_player_label.text = "Player %d" %player_number
		self.scale = Vector2(1.0,1.0)
		player_selected_skin.emit(device) # schickt signal an den Skinselect screen das ausgewäjlt wurde und an andere SKinrecs das reselected wurde falls notwendig
		update_audio_player("click")
		
		
func reselect_skin(device: int) -> void:
	#bei auswahl anderer farben desselben spielers
	if player1_selected and device == 0 and !player_inside.has("Cursor Player 1"):
		is_selected = false
		player1_selected = false
		skin_selected.visible = false
		player_number = device +1
		selected_player_label.text = "Player %d" %player_number
		
	if player2_selected and device == 1 and !player_inside.has("Cursor Player 2"):
		is_selected = false
		player2_selected = false
		skin_selected.visible = false
		player_number = device +1
		selected_player_label.text = "Player %d" %player_number
		
		
		
func update_audio_player(audio_name:String):
	if audio_name == "none": # wird derzeit nicht benutzt
		skin_sounds.stop()
	if audio_name:
		skin_sounds.play()
		skin_sounds["parameters/switch_to_clip"] = audio_name
		
