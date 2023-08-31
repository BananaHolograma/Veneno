class_name Player extends Node2D

signal turn_started
signal turn_finished
signal new_collected_cards(cards: Array[PlayingCard])

const GROUP_NAME = "players"

var is_human: bool = true
var table_position: int = 0
var cards_in_hand: Array[PlayingCard] = []
var collected_cards: Array[PlayingCard] = []
var username: String


func _enter_tree():
	if not is_in_group(GROUP_NAME):
		add_to_group(GROUP_NAME)


func suits_available_for_drop() -> Array:
	return cards_in_hand.filter(func(card: PlayingCard): return not card.suit.is_empty() and not card.is_poison)\
		.map(func(card: PlayingCard): return card.suit)


func poison_cards_in_hand() -> Array[PlayingCard]:
	return cards_in_hand.filter(func(card: PlayingCard): return card.is_poison)


func normal_cards_in_hand() -> Array[PlayingCard]:
	return cards_in_hand.filter(func(card: PlayingCard): return not card.is_poison)
	
	
func collect_cards(cards: Array[PlayingCard]):
	collected_cards.append_array(cards)
	new_collected_cards.emit(cards)
		
