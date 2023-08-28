extends Node2D

@onready var deck_manager = $DeckManager as DeckManager


func _ready():
	var deck = deck_manager.initialize_deck()
	
	for suit_values in deck.values():
		for suit in suit_values.values():
			suit.global_position = Vector2(50, 50)
			add_child(suit)


