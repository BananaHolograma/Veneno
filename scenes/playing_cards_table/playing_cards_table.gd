class_name PlayingCardsTable extends Node2D

@onready var deck_manager = $DeckManager as DeckManager
@onready var CURRENT_DECK: Dictionary = deck_manager.initialize_deck()
@onready var players_zone: Node2D = $PlayersZone
@onready var left_pile: TextureRect = %LeftPile
@onready var center_pile: TextureRect = %CenterPile
@onready var right_pile: TextureRect = %RightPile


@export_range(0, 4, 1) var MAX_NUMBER_OF_PLAYERS: int = 4

const MAX_CARDS_IN_HAND: int = 4

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var deck_in_game: Array[PlayingCard]
var active_player: Player
var current_players: Dictionary = {}


func _ready():
	shuffle_cards()
	start_new_game(["manolito", "pepazo"])
	
	left_pile.modulate.a = 0.1
	center_pile.modulate.a = 0.1
	right_pile.modulate.a = 0.1
	
	
func start_new_game(usernames: Array[String]):
	for username in usernames.slice(0, MAX_NUMBER_OF_PLAYERS):
		add_new_player_to_table(username)
	
	
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


func add_new_player_to_table(username: String):
	var new_player = player_scene.instantiate() as Player
	new_player.username = username
	new_player.name = username
	var cards: Array[PlayingCard] = []
	
	for i in MAX_CARDS_IN_HAND:
		cards.append(deck_in_game.pick_random())
		
	new_player.cards_in_hand = cards
	players_zone.add_child(new_player)
	current_players[new_player.username] = new_player
