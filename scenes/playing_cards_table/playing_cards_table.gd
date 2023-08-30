class_name PlayingCardsTable extends Node

@onready var deck_place: Marker2D = $Playground/DeckPlace
var deck_placeholder_scene = preload("res://scenes/playing_cards_table/deck_placeholder.tscn")

#
### PLAYERS CARDS HAND ZONE
@onready var player_one_card_zone: GridContainer = %PlayerOneCardZone
var card_zone_positions: Dictionary = {}

@export_range(0, 4, 1) var MAX_NUMBER_OF_PLAYERS: int = 4

### Card slot script
#var card_slot_script: String = "res://scenes/player/card_slot.gd"

const MAX_CARDS_IN_HAND: int = 4

var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var active_player: Player
var current_players: Dictionary = {}
var current_deck: DeckPlaceholder
#
func _ready():
	# Temporary for debug purposes, needs to be handled dinamically
	card_zone_positions["ghost"] = {
		"zone": player_one_card_zone, 
		"deal_position": player_one_card_zone.global_position
	}
	
	start_new_game(["ghost"])


	GlobalGameEvents.card_dropped_in_pile.connect(on_card_dropped_in_pile)



func start_new_game(usernames: Array[String]):
	initialise_deck_of_cards_on_table()
	add_new_players_to_table(usernames)
	
	active_player = current_players.values().pick_random()


func initialise_deck_of_cards_on_table():
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



func add_new_players_to_table(usernames: Array[String]):
	var player_position: int = 0

	for username in usernames.slice(0, MAX_NUMBER_OF_PLAYERS):
		add_new_player_to_table(username, player_position)
		player_position += 1

	
func add_new_player_to_table(username: String, player_position: int):
	var new_player = player_scene.instantiate() as Player
	new_player.username = username
	new_player.name = username
	new_player.table_position = player_position
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
			slot.texture = card.symbol_texture.texture
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



