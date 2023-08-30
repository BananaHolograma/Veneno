class_name Player extends Node2D

signal turn_started
signal turn_finished
signal new_collected_cards(cards: Array[PlayingCard])

var is_human: bool = true
var table_position: int = 0
var cards_in_hand: Array[PlayingCard] = []
var collected_cards: Array[PlayingCard] = []
var username: String
var is_player_turn: bool = false:
	set(value):
		if value != is_player_turn:
			if value:
				turn_started.emit()
			else:
				turn_finished.emit()


func pick_card(card: PlayingCard):
	if cards_in_hand.size() == 3:
		cards_in_hand.append(card)
	
	is_player_turn = false


func collect_cards(cards: Array[PlayingCard]):
	collected_cards.append_array(cards)
	new_collected_cards.emit(cards)
		
