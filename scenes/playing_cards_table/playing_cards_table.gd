class_name PlayingCardsTable extends Node

@onready var deck_place: Marker2D = $Playground/DeckPlace

@onready var player_one_card_zone: GridContainer = %PlayerOneCardZone
@onready var player_two_card_zone: GridContainer = %PlayerTwoCardZone
@onready var card_zones: Array[GridContainer] = [player_one_card_zone, player_two_card_zone]

@export_range(0, 4, 1) var MAX_NUMBER_OF_PLAYERS: int = 4

const MAX_CARDS_IN_HAND: int = 4

var deck_placeholder_scene = preload("res://scenes/playing_cards_table/deck_placeholder.tscn")
var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var active_player: Player
var current_players: Dictionary = {}
var card_zone_positions: Dictionary = {}
var current_deck: DeckPlaceholder
#
func _ready():
	# Temporary for debug purposes, needs to be handled dinamically

	
	start_new_game([{"username": "ghost", "human": true}, {"username": "robot", "human": false}])

	GlobalGameEvents.card_dropped_in_pile.connect(on_card_dropped_in_pile)
	GlobalGameEvents.emptied_deck.connect(on_emptied_deck)
	

func start_new_game(players: Array[Dictionary]):
	initialize_deck_of_cards_on_table()
	add_new_players_to_table(players)
	
	active_player = current_players.values().pick_random()


func initialize_deck_of_cards_on_table():
	if deck_place:
		var deck_placeholder = deck_placeholder_scene.instantiate() as DeckPlaceholder
		deck_place.add_child(deck_placeholder)
		current_deck = deck_placeholder


func change_turn_to(player: Player):
	var new_card = current_deck.pick_card_from_deck(player)
		
	if new_card is PlayingCard:
		draw_card_slots(active_player)

	active_player.is_player_turn = false
	player.is_player_turn = true



func add_new_players_to_table(players: Array[Dictionary]):
	var player_position: int = 0
	card_zone_positions.clear()
	
	for player in players.slice(0, MAX_NUMBER_OF_PLAYERS):
		var zone = card_zones[player_position]
		player["table_position"] = player_position
	
		card_zone_positions[player["username"]] = {
			"zone": zone , 
			"deal_position": zone.global_position
		}
		
		add_new_player_to_table(player)
		player_position += 1

	
func add_new_player_to_table(player: Dictionary):
	var new_player = player_scene.instantiate() as Player
	new_player.username = player["username"]
	new_player.name = player["username"]
	new_player.is_human = player["human"]
	new_player.table_position = player["table_position"]
	new_player.cards_in_hand = current_deck.deal_initial_cards(new_player, MAX_CARDS_IN_HAND)
	current_players[new_player.username] = new_player
#
	draw_card_slots(new_player)
#
#
func draw_card_slots(player: Player):
	var player_card_zone = card_zone_positions[player.username]

	var original_global_position = player_card_zone["deal_position"]
	var card_slots: Array[CardSlot] = []
	
	for card in player.cards_in_hand:
		if not card.dealed:
			var slot = CardSlot.new()
			slot.name = "Hand" + card.suit.capitalize() + card.symbol_value.capitalize()
			slot.texture = card.symbol_texture.texture if player.is_human else card.back_texture.texture
			slot.expand_mode = TextureRect.EXPAND_KEEP_SIZE
			slot.size = card.symbol_texture.get_rect().size
			slot.playing_card = card
			slot.player = player
			slot.visible = false
			
			player_card_zone["zone"].add_child(slot)
			
			card_slots.append(slot)
			card.dealed = true
		
	current_deck.run_deal_animation(card_slots, original_global_position)


func on_card_dropped_in_pile(player: Player, card: PlayingCard, pile: PileSlot):
	var player_card_zone = card_zone_positions[player.username]

	for slot in player_card_zone["zone"].get_children():
		if slot.playing_card.card_name == card.card_name:
			slot.queue_free()
			break
		
		
	change_turn_to(current_players["ghost"])

func on_emptied_deck(player: Player):
	pass

