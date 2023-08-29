class_name PlayingCardsTable extends Node

@onready var deck_manager = $DeckManager as DeckManager
@onready var CURRENT_DECK: Dictionary = deck_manager.initialize_deck()
@onready var players_zone: Node2D = $PlayersZone

## PLAYING CARD DROP ZONE
@onready var left_pile: TextureRect = %LeftPile
@onready var center_pile: TextureRect = %CenterPile
@onready var right_pile: TextureRect = %RightPile

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
	start_new_game(["manolito", "pepazo"])
	
	
func start_new_game(usernames: Array[String]):
	var player_position: int = 0
	
	for username in usernames.slice(0, MAX_NUMBER_OF_PLAYERS):
		add_new_player_to_table(username, player_position)
		player_position += 1
	
	
func change_turn_to(player: Player):
	if not deck_in_game.is_empty():
		active_player.pick_card(deck_in_game.pick_random())
	
	active_player.is_player_turn = false
	player.is_player_turn = true


func shuffle_cards():
	for suit_cards in CURRENT_DECK.values():
		for card in suit_cards.values():
			deck_in_game.append(card)
			
	deck_in_game.shuffle()


func add_new_player_to_table(username: String, player_position: int):
	var new_player = player_scene.instantiate() as Player
	new_player.username = username
	new_player.name = username
	var cards: Array[PlayingCard] = []
	
	for _i in MAX_CARDS_IN_HAND:
		var random_card: PlayingCard = deck_in_game.pick_random()
		cards.append(random_card)
		deck_in_game.erase(random_card)
	
	new_player.cards_in_hand = cards
	players_zone.add_child(new_player)
	current_players[new_player.username] = new_player
	
	draw_card_slots(new_player, player_position)


func draw_card_slots(player: Player, player_position: int):
	var player_card_zone = card_zone_positions[player_position]
	for card in player.cards_in_hand:
		var slot = CardSlot.new()
		slot.name = card.suit.capitalize() + " " + card.symbol_value.capitalize()
		slot.texture = card.symbol_texture.texture
		slot.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		slot.size = card.symbol_texture.get_rect().size
		slot.playing_card = card
		slot.player = player
		
		player_card_zone.add_child(slot)
