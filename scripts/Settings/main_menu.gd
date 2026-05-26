extends Control

# für controller grab focus
@onready var music_control: HSlider = $Options/MusicControl
@onready var main_buttons: PanelContainer = $"Main Buttons"

var all_level = [
	preload("uid://dlr1yhmdr3wkh"),
	preload("uid://cnieqsgkay365")
]


@onready var options: Panel = $Options
@onready var main_menu: Control = $"."
@onready var start: Button = $"Main Buttons/MarginContainer/VBoxContainer/start"

func _ready() -> void:
	main_buttons.visible = true
	options.visible = false
	get_tree().paused = false
	start.grab_focus()
	
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
	# random level select
	var x = randi() % all_level.size()
	var selected_scene = all_level[x]
	
	get_tree().change_scene_to_packed(selected_scene)



func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true
	music_control.grab_focus()

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	main_buttons.visible = true
	options.visible = false
	start.grab_focus()


func _on_music_control_value_changed(value: float) -> void:
	Settings.musicVolume = value


func _on_master_control_value_changed(value: float) -> void:
	Settings.masterVolume = value


func _on_sfx_control_value_changed(value: float) -> void:
	Settings.sfxVolume = value


func _on_fullscreen_control_toggled(toggled_on: bool) -> void:
	Settings.fullscreen = toggled_on
