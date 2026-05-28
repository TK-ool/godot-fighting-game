extends CanvasLayer

@onready var camera_2d: Camera2D = $"../Camera2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false
	$Options/MusicControl.value = Settings.musicVolume
	$Options/MasterControl.value = Settings.masterVolume
	$Options/SFXControl.value = Settings.sfxVolume
	$Options/FullscreenControl.button_pressed = Settings.fullscreen
	$Options/CameraControl.button_pressed = Settings.follow_camera
	Settings.changed.connect(settingsChanged)


func settingsChanged():
	$Options/MusicControl.value = Settings.musicVolume
	$Options/MasterControl.value = Settings.masterVolume
	$Options/SFXControl.value = Settings.sfxVolume
	$Options/FullscreenControl.button_pressed = Settings.fullscreen
	$Options/CameraControl.button_pressed = Settings.follow_camera

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Pause Menu"):
			if get_tree().paused:
				visible = false
				get_tree().paused = false
			else:
				visible = true
				get_tree().paused = true
				$Options/MasterControl.grab_focus()


func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_main_menu_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.on_transition_finished
	Global.load_menu()


func _on_master_control_value_changed(value: float) -> void:
	Settings.masterVolume = value


func _on_sfx_control_value_changed(value: float) -> void:
	Settings.sfxVolume = value


func _on_music_control_value_changed(value: float) -> void:
	Settings.musicVolume = value


func _on_fullscreen_control_toggled(toggled_on: bool) -> void:
	Settings.fullscreen = toggled_on


func _on_camera_control_toggled(toggled_on: bool) -> void:
	Settings.follow_camera = toggled_on
	if toggled_on:
		camera_2d.enabled = true
	else:
		camera_2d.enabled = false
