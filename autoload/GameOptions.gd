class_name GameOptions extends Node


var default_game_parameters: Dictionary = {
		"players": [{"username": "ghost", "human": true},{"username": "robot", "human": false}] as Array[Dictionary],
		"poison_suit": "hearts",
		"rounds": 2
	}

var active_game_parameters : Dictionary = {}

func new_game(parameters: Dictionary = {}):
	active_game_parameters  = parameters if parameters.keys().size() > 0 else default_game_parameters
	
	return active_game_parameters
