class_name PileSlot extends TextureRect

signal pile_collected(player: Player, pile: PileSlot)

@onready var current_suit: String
@onready var current_points: float = 0.0
@onready var current_poison_points: float = 0.0
@onready var cards_in_pile: Array[PlayingCard] = []

const GROUP_NAME = "piles"

@onready var info_marker: Marker2D = $"../InfoMarker"
@onready var points_label: Label = $"../InfoMarker/PointsLabel"
@onready var poison_points_label: Label = $"../InfoMarker/PoisonPointsLabel"

const suit_symbol_scene: PackedScene = preload("res://scenes/deck/suit_symbols/suit_symbol.tscn")

func _ready():
	modulate.a = 1.0
	self_modulate.a = 0.2
	
	if not is_in_group(GROUP_NAME):
		add_to_group(GROUP_NAME)
	
	
	if points_label and poison_points_label:
		points_label.text = ""
		poison_points_label.text = ""
		
		
func _can_drop_data(_at_position, data):
	return data.playing_card is PlayingCard and card_can_be_dropped_in_this_pile(data.playing_card)
	

func _drop_data(at_position, data):
	drop_card_in_pile(data.player, data.playing_card)


func drop_card_in_pile(player: Player, card: PlayingCard):
	if card_can_be_dropped_in_this_pile(card):	
		if current_suit.is_empty() and not card.is_poison:
			show_suit_symbol(card.suit)
		
		add_points_to_pile(card)
		add_card_to_pile(card)
		check_points(player)
		
		player.cards_in_hand.erase(card)
		
		GlobalGameEvents.emit_card_dropped_in_pile(player, card, self)
			

func card_can_be_dropped_in_this_pile(card: PlayingCard) -> bool:
	var players = get_tree().get_nodes_in_group("players")
	var players_have_cards_in_their_hand = players.filter(func(player: Player): return player.cards_in_hand.size() > 0).size() > 0

	
	return players_have_cards_in_their_hand	and card.is_poison and not current_suit.is_empty() or \
		(not card.is_poison and current_suit.is_empty() and suit_is_not_active(card.suit)) \
		or card.suit == current_suit


func suit_is_not_active(suit: String) -> bool:
	var suits = get_tree().get_nodes_in_group(GROUP_NAME).map(func(pile: PileSlot): return pile.current_suit)
	
	return suit not in suits


func add_card_to_pile(card: PlayingCard) -> void:
	var card_pile_texture = TextureRect.new()
	card_pile_texture.name = card.card_name
	card_pile_texture.texture = card.symbol_texture.texture
	card_pile_texture.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	card_pile_texture.size = card.symbol_texture.get_rect().size
	card_pile_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE

	if card.is_poison:
		card_pile_texture.position.y += 21
		var tween = create_tween()
		tween.tween_property(card_pile_texture, "self_modulate", Color.LIGHT_GREEN, 0.35).from(Color.LIME_GREEN)

	add_child(card_pile_texture)

	cards_in_pile.append(card)


func add_points_to_pile(card: PlayingCard) -> void:
	current_points += card.current_value 
	current_poison_points += card.current_value if card.is_poison else 0.0
	
	if current_points > 0:
		points_label.text = str(current_points)
		poison_points_label.text = str(current_poison_points)
	

func show_suit_symbol(suit):
	var suit_symbol = suit_symbol_scene.instantiate() as SuitSymbol
	suit_symbol.current_suit = suit
	current_suit = suit
	info_marker.add_child(suit_symbol)
	self_modulate.a = 0.0


func clean_info_marker():
	if current_suit.is_empty():
		for child in info_marker.get_children():
			if child is SuitSymbol:
				child.queue_free()
				
		points_label.text = ""
		poison_points_label.text = ""
	

func check_points(player: Player):
	if current_points >= 13:	
		player.collect_cards(cards_in_pile)
		GlobalGameEvents.emit_pile_collected(player, cards_in_pile, self)
		reset_pile()


func reset_pile() -> void:
	current_suit = ""
	current_points = 0.0
	current_poison_points = 0.0
	cards_in_pile.clear()
	self_modulate.a = 0.2
	clean_info_marker()
