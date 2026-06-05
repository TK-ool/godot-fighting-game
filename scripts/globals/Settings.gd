extends Node

signal changed

func _ready() -> void:
	pass


# The volume of music
var musicVolume: float = 0.3:
	set(value):
		musicVolume = value
		changed.emit()


# The master volume
var masterVolume: float = 0.3:
	set(value):
		masterVolume = value
		changed.emit()


# The volume of SFX
var sfxVolume: float = 0.3:
	set(value):
		sfxVolume = value
		changed.emit()


var fullscreen: bool:
	set(value):
		fullscreen = value
		if value:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		changed.emit()
		
var follow_camera: bool = false:
	set(value):
		follow_camera = value
		changed.emit()
			
