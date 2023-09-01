extends Control

@onready var option_button: OptionButton = $CenterContainer/MarginContainer/VBoxContainer/OptionButton
var playing_cards_table_scene: PackedScene = preload("res://scenes/playing_cards_table/playing_cards_table.tscn")

var parameters: Dictionary = {
		"players": [{"username": "ghost", "human": true},{"username": "robot", "human": false}] as Array[Dictionary],
		"poison_suit": "hearts",
		"rounds": 2
	}
	


func _on_start_game_pressed():
	if parameters.players.size() > 1:
		GlobalGameOptions.new_game(parameters)
		get_tree().change_scene_to_packed(playing_cards_table_scene)


func _on_option_button_item_selected(index):
	set_players(option_button.get_selected_id())


func set_players(amount: int):
	var amount_of_players = [
		{"username": "ghost", "human": true},
		{"username": "robot", "human": false}
	] as Array[Dictionary]
	
	match(amount):
		3:
			amount_of_players.append({"username": "robot2", "human": false})
		4:
			amount_of_players.append_array([{"username": "robot2", "human": false}, {"username": "robot3", "human": false}])
			
	parameters["players"] = amount_of_players


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
