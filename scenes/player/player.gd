class_name Player extends Node2D

@onready var cards_in_hand_layer: CanvasLayer = $CardsInHand


signal turn_started
signal turn_finished
signal new_collected_cards(cards: Array[PlayingCard])

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


func _ready():
	_draw_card_slots()

func pick_card(card: PlayingCard):
	if cards_in_hand.size() == 3:
		cards_in_hand.append(card)
	
	is_player_turn = false


func collect_cards(cards: Array[PlayingCard]):
	collected_cards.append_array(cards)
	new_collected_cards.emit(cards)

func _draw_card_slots():
	for card in cards_in_hand:
		var slot = TextureRect.new()
		slot.texture = card.symbol_texture.texture
		slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slot.size = card.symbol_texture.get_rect().size
		
		cards_in_hand_layer.add_child(slot)
		
		var panel = Panel.new()
		panel.custom_minimum_size = slot.size
		panel.show_behind_parent = true
		slot.add_child(panel)

		
