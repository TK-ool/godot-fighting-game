extends Control

# für controller grab focus
@onready var music_control: HSlider = $Options/MusicControl
@onready var main_buttons: PanelContainer = $"Main Buttons"
@onready var options: Panel = $Options
@onready var main_menu: Control = $"."
@onready var start: Button = $"Main Buttons/MarginContainer/VBoxContainer/start"
@onready var test_area: Button = $"Main Buttons/MarginContainer/VBoxContainer/Test_Area"
@onready var options_button: Button = $"Main Buttons/MarginContainer/VBoxContainer/options"
@onready var exit: Button = $"Main Buttons/MarginContainer/VBoxContainer/exit"


@onready var focus_pointer: Sprite2D = $"Main Buttons/Focus_pointer"

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
	ScreenTransition.transition()
	await ScreenTransition.on_transition_finished
	get_tree().change_scene_to_file("uid://bvn5wf5gvr2lm") # Color selection Screen
	


func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true
	$Options/MasterControl.grab_focus()

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


func _on_test_area_pressed() -> void:
	ScreenTransition.transition()
	await ScreenTransition.on_transition_finished
	get_tree().change_scene_to_file("uid://vk0kxs4fulii") # Test_Area level
	
	

# focus pointer position
func _on_start_focus_entered() -> void:
	focus_pointer.global_position = start.global_position + Vector2(-30,start.size.y / 2)
	
func _on_test_area_focus_entered() -> void:
	focus_pointer.global_position = test_area.global_position + Vector2(-30,test_area.size.y / 2)

func _on_options_focus_entered() -> void:
	focus_pointer.global_position = options_button.global_position + Vector2(-30,options_button.size.y / 2)

func _on_exit_focus_entered() -> void:
	focus_pointer.global_position = exit.global_position + Vector2(-30,exit.size.y / 2)
