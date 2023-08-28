class_name DeckManager extends Node

enum TYPES_OF_DECK {
	FRENCH,
	SPANISH
}

var playing_card_scene: PackedScene = preload("res://scenes/deck/playing_card.tscn")
var POISON_SUIT: String = "HEARTS"

var BASE_FRENCH_DECK: Dictionary = {"SPADES": {}, "CLUBS": {}, "HEARTS": {}, "DIAMONDS": {}}

var FRENCH_TABLE_VALUES: Dictionary = {
	"ace": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 0.5, "9": 0.5, "jack": 0.5, "queen": 0.5, "king": 0.5
}

var base_french_card_white_path: String = "res://assets/cards/french/{suit}/{value}_white.png"
var base_french_card_path: String = "res://assets/cards/french/{suit}/{value}.png"

var back_texture = load("res://assets/backs/back_black_basic_white.png")


func initialize_deck(type: TYPES_OF_DECK = TYPES_OF_DECK.FRENCH) -> Dictionary:
	match(type):
		TYPES_OF_DECK.FRENCH:
			return initialize_french_deck()
			
		TYPES_OF_DECK.SPANISH:
			return initialize_spanish_deck()
	
	return {}
		
		
func initialize_french_deck() -> Dictionary:
	for suit in BASE_FRENCH_DECK.keys():
		for value in FRENCH_TABLE_VALUES.keys():
			BASE_FRENCH_DECK[suit][value] = instantiate_french_playing_card(suit, value)
			
	return BASE_FRENCH_DECK


func initialize_spanish_deck() -> Dictionary:
	return {}


func change_poison_suit(suit: String):
	suit = suit.to_upper()
	
	if suit in BASE_FRENCH_DECK.keys():
		POISON_SUIT = suit


func instantiate_french_playing_card(suit: String, value: String) -> PlayingCard:	
	suit = suit.to_lower()
	
	var playing_card = playing_card_scene.instantiate() as PlayingCard
	
	return playing_card.initialize({
		"symbol_texture": load(base_french_card_white_path.format({"suit": suit, "value": value + "_" + suit})),
		"selected_texture": load(base_french_card_path.format({"suit": suit, "value": value + "_" + suit})),
		"back_texture": back_texture,
		"suit": suit,
		"symbol_value": value,
		"current_value": FRENCH_TABLE_VALUES[value],
		"table_value": FRENCH_TABLE_VALUES[value],
		"is_poison": suit == POISON_SUIT.to_lower()
	})

