extends Control


@onready var main_buttons: PanelContainer = $"Main Buttons"
@onready var options: Panel = $Options
@onready var main_menu: Control = $"."

func _ready() -> void:
	main_buttons.visible = true
	options.visible = false
	get_tree().paused = false
	
	$Options/MusicControl.value = Settings.musicVolume
	$Options/MasterControl.value = Settings.masterVolume
	$Options/SFXControl.value = Settings.sfxVolume
	$Options/FullscreenControl.button_pressed = Settings.fullscreen
	
	Settings.changed.connect(settingsChanged)


func settingsChanged():
	$Options/MusicControl.value = Settings.musicVolume
	$Options/MasterControl.value = Settings.masterVolume
	$Options/SFXControl.value = Settings.sfxVolume
	$Options/FullscreenControl.button_pressed = Settings.fullscreen


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenen/Level.tscn")



func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	main_buttons.visible = true
	options.visible = false


func _on_music_control_value_changed(value: float) -> void:
	Settings.musicVolume = value


func _on_master_control_value_changed(value: float) -> void:
	Settings.masterVolume = value


func _on_sfx_control_value_changed(value: float) -> void:
	Settings.sfxVolume = value


func _on_fullscreen_control_toggled(toggled_on: bool) -> void:
	Settings.fullscreen = toggled_on
