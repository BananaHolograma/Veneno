class_name PlayingCard extends Node2D

var symbol_texture: Sprite2D
var back_texture: Sprite2D

var table_value: int
var symbol_value: int
var current_value: int
var is_poison: bool = false


func _enter_tree():
	add_child(symbol_texture)
	add_child(back_texture)


func initialize(parameters: Dictionary) -> PlayingCard:
	var symbol_sprite = Sprite2D.new()
	symbol_sprite.texture = parameters["symbol_texture"]
	symbol_texture = symbol_sprite
	
	var back_sprite = Sprite2D.new()
	back_sprite.texture = parameters["back_texture"]
	back_sprite.visible = false
	back_texture = back_sprite
	
	table_value = parameters["table_value"]
	current_value = parameters["current_value"]
	is_poison = parameters["is_poison"]
	
	return self	
