class_name PlayingCard extends Node2D

var symbol_texture: Sprite2D
var selected_texture: Sprite2D
var back_texture: Sprite2D

var suit: String
var symbol_value: String
var table_value: float
var current_value: float
var is_poison: bool = false

var is_selected: bool = false

func _enter_tree():
	add_child(symbol_texture)
	add_child(selected_texture)
	add_child(back_texture)


func initialize(parameters: Dictionary) -> PlayingCard:
	var symbol_sprite = Sprite2D.new()
	symbol_sprite.texture = parameters["symbol_texture"]
	symbol_texture = symbol_sprite
	
	var selected_sprite = Sprite2D.new()
	selected_sprite.texture = parameters["selected_texture"]
	selected_sprite.visible = false
	selected_texture = selected_sprite
	
	var back_sprite = Sprite2D.new()
	back_sprite.texture = parameters["back_texture"]
	back_sprite.visible = false
	back_texture = back_sprite
	
	suit = parameters["suit"]
	symbol_value = parameters["symbol_value"]
	table_value = parameters["table_value"]
	current_value = parameters["current_value"]
	is_poison = parameters["is_poison"]
	
	return self	
