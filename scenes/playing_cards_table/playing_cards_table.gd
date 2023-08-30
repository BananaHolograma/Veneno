class_name PlayingCardsTable extends Node

@onready var CURRENT_DECK: Dictionary = GlobalDeckManager.initialize_deck()

## PLAYING CARD DROP ZONE
@onready var left_pile: PileSlot = %LeftPile
@onready var center_pile: PileSlot = %CenterPile
@onready var right_pile: PileSlot = %RightPile

## PLAYERS CARDS HAND ZONE
@onready var player_one_card_zone: GridContainer = %PlayerOneCardZone
@onready var player_two_card_zone: GridContainer = %PlayerTwoCardZone
@onready var player_three_card_zone: GridContainer = %PlayerThreeCardZone
@onready var player_four_card_zone: GridContainer = %PlayerFourCardZone

@onready var card_zone_positions: Array[GridContainer] = [player_one_card_zone, player_two_card_zone, player_three_card_zone, player_four_card_zone]

@export_range(0, 4, 1) var MAX_NUMBER_OF_PLAYERS: int = 4

## Card slot script
var card_slot_script: String = "res://scenes/player/card_slot.gd"

const MAX_CARDS_IN_HAND: int = 4

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var deck_in_game: Array[PlayingCard]
var active_player: Player
var current_players: Dictionary = {}


func _ready():
	shuffle_cards()
	start_new_game(["ghost"])
	
	left_pile.card_dropped.connect(on_card_dropped_in_pile)
	center_pile.card_dropped.connect(on_card_dropped_in_pile)
	right_pile.card_dropped.connect(on_card_dropped_in_pile)


func start_new_game(usernames: Array[String]):
	var player_position: int = 0
	
	for username in usernames.slice(0, MAX_NUMBER_OF_PLAYERS):
		add_new_player_to_table(username, player_position)
		player_position += 1
		
	active_player = current_players["ghost"]
	
	
func change_turn_to(player: Player):
	if not deck_in_game.is_empty():
		active_player.pick_card(pick_random_card())

	draw_card_slots(active_player)
	active_player.is_player_turn = false
	player.is_player_turn = true


func shuffle_cards():
	for suit_cards in CURRENT_DECK.values():
		for card in suit_cards.values():
			deck_in_game.append(card)
			
	deck_in_game.shuffle()
	

func pick_random_card():
	var card = deck_in_game.pick_random()
	
	if card:
		deck_in_game.erase(card)
		
	return card

func add_new_player_to_table(username: String, player_position: int):
	var new_player = player_scene.instantiate() as Player
	new_player.username = username
	new_player.name = username
	new_player.table_position = player_position

	new_player.cards_in_hand = deal_cards(new_player)
	current_players[new_player.username] = new_player
	
	draw_card_slots(new_player)


func draw_card_slots(player: Player):
	var player_card_zone = card_zone_positions[player.table_position]
	
	for child in player_card_zone.get_children():
		child.queue_free()
		
	for card in player.cards_in_hand:
		var slot = CardSlot.new()
		slot.texture = card.symbol_texture.texture
		slot.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		slot.size = card.symbol_texture.get_rect().size
		slot.playing_card = card
		slot.player = player
		
		player_card_zone.add_child(slot)
		slot.name = "Hand" + card.suit.capitalize() + card.symbol_value.capitalize()


func on_card_dropped_in_pile(player, card, pile):
	change_turn_to(current_players["ghost"])
	

func deal_cards(player: Player) -> Array[PlayingCard]:
	var cards: Array[PlayingCard] = []
	
	# Edge case when all the cards in the first deal are poison
	while cards.is_empty() or cards.filter(func(card): return card.is_poison).size() == cards.size():
		deck_in_game.append_array(cards)
		
		for _i in MAX_CARDS_IN_HAND:
			cards.append(pick_random_card())
			
	return cards
	
	
