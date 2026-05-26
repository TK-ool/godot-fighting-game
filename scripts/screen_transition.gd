extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer




func _ready() -> void:
	color_rect.visible = false



func transition():
	color_rect.visible = true
	animation_player.play("fade_to _black")
