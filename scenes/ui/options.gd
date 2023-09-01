extends Control


@onready var windows_mode_checkbox: OptionButton = $Parameters/VBoxContainer/HBoxContainer/VBoxContainer2/WindowsModeCheckbox
@onready var music: HSlider = $Parameters/VBoxContainer/HorizontalContainer/Sliders/Music
@onready var sfx: HSlider = $Parameters/VBoxContainer/HorizontalContainer/Sliders/SFX


func _ready():
	music.value = _get_actual_volume_db_from_bus("Music")
	sfx.value = _get_actual_volume_db_from_bus("SFX")
	
func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_windows_mode_checkbox_item_selected(index):
	DisplayServer.window_set_mode(windows_mode_checkbox.get_selected_id())


func _on_vsync_checkbox_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	

func _on_music_value_changed(value):
	change_volume(AudioServer.get_bus_index("Music"), value)


func _on_sfx_value_changed(value):
	change_volume(AudioServer.get_bus_index("SFX"), value)


func change_volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _get_actual_volume_db_from_bus(name: String):
	return db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(name)))
