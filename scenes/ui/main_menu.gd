extends CanvasLayer

@onready var new_game: Button = $MainMenu/MarginContainer/CenterContainer/VBoxContainer/NewGame
@onready var options: Button = $MainMenu/MarginContainer/CenterContainer/VBoxContainer/Options
@onready var quit: Button = $MainMenu/MarginContainer/CenterContainer/VBoxContainer/Quit

var start_new_game_scene: PackedScene = preload("res://scenes/ui/start_new_game.tscn")
var option_menu_scene: PackedScene = preload("res://scenes/ui/options.tscn")


func _ready():
	new_game.grab_focus()


func _on_new_game_pressed():
	get_tree().change_scene_to_packed(start_new_game_scene)


func _on_options_pressed():
	get_tree().change_scene_to_packed(option_menu_scene)


func _on_quit_pressed():
	get_tree().quit()


