extends Control


@onready var windows_mode_checkbox: OptionButton = $Parameters/VBoxContainer/HBoxContainer/VBoxContainer2/WindowsModeCheckbox


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")


func _on_windows_mode_checkbox_item_selected(index):
	DisplayServer.window_set_mode(windows_mode_checkbox.get_selected_id())


func _on_vsync_checkbox_toggled(button_pressed):
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
