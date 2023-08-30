class_name SuitSymbol extends Node2D

@onready var heart_symbol: Sprite2D = $HeartSymbol
@onready var diamond_symbol: Sprite2D = $DiamondSymbol
@onready var spade_symbol: Sprite2D = $SpadeSymbol
@onready var club_symbol: Sprite2D = $ClubSymbol
@onready var animation_player: AnimationPlayer = $AnimationPlayer


@export var current_suit: String

func _ready():
	if not current_suit.is_empty():
		show_suit(current_suit)


func show_suit(suit: String):
	if is_node_ready():
		heart_symbol.visible = suit == "hearts"
		diamond_symbol.visible = suit == "diamonds"
		spade_symbol.visible = suit == "spades"
		club_symbol.visible = suit == "clubs"
		
		if animation_player:
			animation_player.play("bounce")
