class_name PlayingCardsTable extends Node


@onready var audio_stream_player: AudioStreamPlayer2D = $BackgroundMusic
@onready var playground: CanvasLayer = $Playground
@onready var deck_place: Marker2D = $Playground/DeckPlace
@onready var players: Node = $Players
@onready var card_zones: Array[GridContainer] = [
	%PlayerOneCardZone,
 	%PlayerThreeCardZone,
 	%PlayerTwoCardZone,
 	%PlayerFourCardZone
]

@onready var end_game_screen: PackedScene = preload("res://scenes/ui/end_game_screen.tscn")

@export_range(0, 4, 1) var MAX_NUMBER_OF_PLAYERS: int = 4

const MAX_CARDS_IN_HAND: int = 4
var CURRENT_POISON_SUIT: String = "hearts"

var deck_placeholder_scene = preload("res://scenes/playing_cards_table/deck_placeholder.tscn")
var player_scene: PackedScene = preload("res://scenes/player/player.tscn")
var active_player: Player
var current_players: Dictionary = {}
var card_zone_positions: Dictionary = {}
var current_deck: DeckPlaceholder

var turns: Array = []
var start_counting_players_cards_in_hand: bool = false

func _ready():
	start_new_game(GlobalGameOptions.active_game_parameters)
	GlobalGameEvents.card_dropped_in_pile.connect(on_card_dropped_in_pile)
	GlobalGameEvents.emptied_deck.connect(on_emptied_deck)
	
	
func start_new_game(parameters: Dictionary):
	initialize_deck_of_cards_on_table()
	await add_players_to_table(parameters["players"])
	change_turn_to(active_player)


func initialize_deck_of_cards_on_table():
	if not deck_place:
		push_error("The table needs a start position to initialize the deck, deck place must be set up")
	
	var deck_placeholder = deck_placeholder_scene.instantiate() as DeckPlaceholder
	deck_place.add_child(deck_placeholder)
	current_deck = deck_placeholder
	

func change_turn_to(player: Player):
	GlobalGameEvents.emit_turn_finished(active_player)
	active_player = player
	GlobalGameEvents.emit_turn_started(player)
	
	active_player.execute_robot_movement()


func add_players_to_table(new_players: Array[Dictionary]):
	var player_position: int = 0
	card_zone_positions.clear()
	
	for player in new_players.slice(0, MAX_NUMBER_OF_PLAYERS):
		var zone = card_zones[player_position]
		player["table_position"] = player_position
		
		card_zone_positions[player["username"]] = {
			"zone": zone , 
			"deal_position": zone.global_position,
			"drop_card_texture": zone.get_node_or_null("DropCardTexture")
		}
		
		add_player_to_table(player)
		await (get_tree().create_timer(0.45 * MAX_CARDS_IN_HAND)).timeout
		player_position += 1
	
		
	turns.append_array(current_players.values())
	active_player = turns.pick_random()

	
func add_player_to_table(player: Dictionary):
	var new_player = player_scene.instantiate() as Player
	new_player.username = player["username"]
	new_player.name = player["username"]
	new_player.is_human = player["human"]
	new_player.table_position = player["table_position"]
	new_player.card_zone = card_zone_positions[new_player.username]
	new_player.cards_in_hand = current_deck.deal_initial_cards(new_player, MAX_CARDS_IN_HAND)
	current_players[new_player.username] = new_player
	
	players.add_child(new_player)
	
	draw_card_slots(new_player)
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
			slot.visible = card.dealed
			
			player_card_zone["zone"].add_child(slot)
			
			card_slots.append(slot)
			card.dealed = true
		
	current_deck.run_deal_animation(card_slots, original_global_position)


func update_player_card_hand(player: Player) -> void:
	if player.cards_in_hand.size() < MAX_CARDS_IN_HAND:
		var new_card = current_deck.pick_card_from_deck(player)

		if new_card is PlayingCard:
			draw_card_slots(player)
		

func on_card_dropped_in_pile(player: Player, card: PlayingCard, _pile: PileSlot):
	var player_card_zone = card_zone_positions[player.username]

	for slot in player_card_zone["zone"].get_children():
		if slot is CardSlot and slot.playing_card.card_name == card.card_name:
			slot.queue_free()
			break
	
	update_player_card_hand(player)
	
	var current_index: int = turns.find(player)
	var next_player: Player

	if turns.size() - 1 >= current_index + 1:
		next_player = turns[current_index + 1]
	else:
		next_player = turns[0]
	
	change_turn_to(next_player)
	show_end_screen_when_no_cards_remaining()
	

func on_emptied_deck(player: Player):
	start_counting_players_cards_in_hand = true


func show_end_screen_when_no_cards_remaining():
	if start_counting_players_cards_in_hand:
		var remaining_cards: int = 0
		for current_player in current_players.values() as Array[Player]:
			remaining_cards += current_player.cards_in_hand.size()
			if remaining_cards == 0:
				var end_game = end_game_screen.instantiate() as EndGameScreen
				playground.add_child(end_game)
				end_game.display_result(current_players.values())
			
	


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
