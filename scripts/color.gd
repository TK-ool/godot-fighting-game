extends ColorRect
# Called when the node enters the scene tree for the first time.
@onready var color_selected: Sprite2D = $ColorSelected
var normal_color: Color
var entered_device: int
var is_in_rect:bool = false
var is_selected: bool = false

func _ready() -> void:
	normal_color = self.color


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_in_rect:
		if Input.is_action_just_pressed("P%d_accept" %entered_device):
			print("trzue")
			is_selected = true
			color_selected.visible = true
			self.color = Color(0.4,0.4,0.4,1)
			self.scale = Vector2(1.0,1.0)
		if Input.is_action_just_pressed("P%d_cancel" %entered_device):
			is_selected = false
			self.scale = Vector2(1.2,1.2)
			color_selected.visible = false
			self.color = normal_color


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_selected == false:
		if body is Cursor:
			body.is_in_colorrect = true
			body.player_color = self.color
			self.scale = Vector2(1.2,1.2)
			entered_device = body.device
			is_in_rect = true



func _on_area_2d_body_exited(body: Node2D) -> void:
		if body is Cursor:
			if is_selected == false:
				body.is_in_colorrect = false
				self.scale = Vector2(1.0,1.0)
				entered_device = 99 # platzhalternummer
				is_in_rect = false
