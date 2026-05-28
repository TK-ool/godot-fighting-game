extends Camera2D

@onready var camera_2d: Camera2D = $"."

@export var zoom_offset : float = 0.2
@export var debug_mode: bool = false
var camera_rect : Rect2
var viewport_rect : Rect2

func _ready() -> void:
	viewport_rect = get_viewport_rect()
	
func _process(_delta: float) -> void:
	
	var players = get_tree().get_nodes_in_group("Players")
	if players.size() >= 1:
		set_process(players.size() >0)
		camera_rect = Rect2(players[0].global_position, Vector2())
		for player in players:
			camera_rect = camera_rect.expand(player.global_position)
		
		global_position = calculate_center(camera_rect)
		zoom =  calculate_zoom(camera_rect, viewport_rect.size)
		if debug_mode:
			queue_redraw()
	else:
		global_position = Vector2(0,0)
	
	
func calculate_center (rect: Rect2) -> Vector2:
	return Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y / 2
	)
	
	
func calculate_zoom(rect: Rect2, viewport_size: Vector2) -> Vector2:
	
		var cam_zoom:float = min(clamp((viewport_size.x / rect.size.x +zoom_offset)/ 2, 1, 1.5),clamp((viewport_size.y /rect.size.y +zoom_offset)  / 2, 1, 1.5))
		var final_zoom = lerp(max(zoom.y,zoom.x), cam_zoom, 0.009) # geschwindigkeit der camera anpassen letzter wert vom lerp
		return Vector2(final_zoom, final_zoom)

	

func _draw() -> void:
	if not debug_mode:
		return
	draw_set_transform(-global_position)
	draw_rect(camera_rect, Color("#ff4fff"), false)
	draw_circle(calculate_center(camera_rect), 5, Color("#ff4fff"))
