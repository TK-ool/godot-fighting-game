class_name Cursor
extends CharacterBody2D

signal player_selected_color
signal player_deselected_color

@onready var player_name: Label = $Player_name

@export var device : int = 0
var playernumber: int
var is_in_colorrect: bool = false
var player_color: Color
var player_selected:bool = false
const SPEED: float = 500.0

func _ready() -> void:
	playernumber = device +1
	player_name.text = "Player %d" %playernumber

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("P%d_links" % device, "P%d_rechts" % device, "P%d_oben" % device, "P%d_unten" % device)
	if player_selected == false:
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
	else:
		velocity = Vector2(0,0)
		
	if is_in_colorrect:
		if Input.is_action_just_pressed("P%d_accept" %device):
			player_selected_color.emit(device)
			player_selected = true
			if device == 0:
				Global.P1_Color = player_color
			if device == 1:
				Global.P2_Color = player_color
			self.visible = false
			
	if player_selected:
		if Input.is_action_just_pressed("P%d_cancel" %device):
			player_deselected_color.emit(device)
			player_selected = false
			self.visible = true
		

	move_and_slide()
