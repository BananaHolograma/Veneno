class_name PileSlot extends TextureRect

@onready var current_suit: String
@onready var current_points: float = 0.0
@onready var current_poison_points: float = 0.0
@onready var cards_in_pile: Array[PlayingCard] = []

const GROUP_NAME = "piles"

@onready var info_marker: Marker2D = $"../InfoMarker"
@onready var points_label: Label = $"../InfoMarker/PointsLabel"
@onready var poison_points_label: Label = $"../InfoMarker/PoisonPointsLabel"

const suit_symbol_scene: PackedScene = preload("res://scenes/deck/suit_symbols/suit_symbol.tscn")

var actual_player: Player

func _ready():
	modulate.a = 1.0
	self_modulate.a = 0.2
	
	if not is_in_group(GROUP_NAME):
		add_to_group(GROUP_NAME)
	
	
	if points_label and poison_points_label:
		points_label.text = ""
		poison_points_label.text = ""
	
	GlobalGameEvents.pile_collected.connect(on_pile_collected)
	GlobalGameEvents.turn_started.connect(on_turn_started)
		
		
func _can_drop_data(_at_position, data):
	return data.playing_card is PlayingCard \
		and data.player == actual_player \
		and card_can_be_dropped_in_this_pile(data.playing_card)
	

func _drop_data(at_position, data):
	drop_card_in_pile(data.player, data.playing_card)


func drop_card_in_pile(player: Player, card: PlayingCard):
	if player == actual_player and card_can_be_dropped_in_this_pile(card):	
		if current_suit.is_empty() and not card.is_poison:
			show_suit_symbol(card.suit)
		
		if not player.is_human:
			player.card_zone["drop_card_texture"].visible = true
			player.card_zone["drop_card_texture"].texture = card.symbol_texture.texture.duplicate()
			var tween = create_tween()
			tween.tween_property(player.card_zone["drop_card_texture"], "global_position", global_position, 1.0)\
			.from(player.card_zone["drop_card_texture"].global_position + card.symbol_texture.get_rect().size)
			tween.tween_callback(on_robot_dropped_card_animation_finished.bind(player, card))
		else:
			confirm_card_in_pile(player, card)


func on_robot_dropped_card_animation_finished(player, card):
	player.card_zone["drop_card_texture"].visible = false
	player.card_zone["drop_card_texture"].texture = null
	player.card_zone["drop_card_texture"].global_position = player.card_zone["zone"].global_position
	confirm_card_in_pile(player, card)


func confirm_card_in_pile(player: Player, card: PlayingCard):
	add_points_to_pile(card)
	add_card_to_pile(card)
	check_points(player)

	player.cards_in_hand.erase(card)

	GlobalGameEvents.emit_card_dropped_in_pile(player, card, self)


func card_can_be_dropped_in_this_pile(card: PlayingCard) -> bool:
	var poison_allowed = card.is_poison and not current_suit.is_empty()
	var empty_pile = current_suit.is_empty() and suit_is_not_active(card.suit) and not card.is_poison 
	var suit_is_allowed = card.suit == current_suit and not card.is_poison
	
	return poison_allowed or empty_pile or suit_is_allowed


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


func clean_info_marker():
	if current_suit.is_empty():
		for child in info_marker.get_children():
			if child is SuitSymbol:
				child.queue_free()
				
		points_label.text = ""
		poison_points_label.text = ""
	

func check_points(player: Player):
	if current_points >= 13 and actual_player == player:	
		GlobalGameEvents.emit_pile_collected(player, cards_in_pile, self)


func reset_pile() -> void:
	current_suit = ""
	current_points = 0.0
	current_poison_points = 0.0
	cards_in_pile.clear()
	self_modulate.a = 0.2
	clean_info_marker()
	
	for child in get_children():
		if child is TextureRect:
			child.queue_free()


func on_pile_collected(player: Player, cards: Array[PlayingCard], pile: PileSlot) -> void:
	if pile == self and player == actual_player:
		player.collect_cards(cards_in_pile)
		reset_pile()


func on_turn_started(player: Player) -> void:
	actual_player = player
