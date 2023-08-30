class_name DeckPlaceholder extends Node2D

@onready var one_card: Sprite2D = $OneCard
@onready var half: Sprite2D = $Half
@onready var full: Sprite2D = $Full
@onready var card_texture_placeholder: Sprite2D = $CardTexturePlaceholder

var CURRENT_DECK: Array[PlayingCard]

func _ready():
	CURRENT_DECK = GlobalDeckManager.initialize_deck()
	update_sprite_based_on_deck_cards()


func deal_initial_cards(player: Player, amount: int) -> Array[PlayingCard]:
	var cards: Array[PlayingCard] = []

	# Edge case when all the cards in the first deal are poison
	while cards.is_empty() or cards.filter(func(card): return card.is_poison).size() == cards.size():
		CURRENT_DECK.append_array(cards)

		for _i in amount:
			cards.append(pick_card_from_deck(player))

	return cards


func pick_card_from_deck(player: Player):
	if CURRENT_DECK.is_empty():
		return null
	
	var card = CURRENT_DECK.pick_random()
	
	if card:
		CURRENT_DECK.erase(card)
		player.cards_in_hand.append(card)

	update_sprite_based_on_deck_cards()
	
	if CURRENT_DECK.is_empty():
		GlobalGameEvents.emit_emptied_deck(player)
	
	GlobalGameEvents.emit_picked_card_from_deck(player, card)

	return card


func update_sprite_based_on_deck_cards():
	var percentage = CURRENT_DECK.size() / 52.0
	
	full.visible = percentage >= 0.75
	half.visible = percentage >= 0.5
	one_card.visible = percentage >= 0.01



func run_deal_animation(cards: Array[CardSlot], deal_position: Vector2):
	if not cards.is_empty():
		
		var card = cards.back() as CardSlot
		
		if card.is_inside_tree():
			card_texture_placeholder.texture = card.texture
			var tween = create_tween()
			tween.tween_property(card_texture_placeholder, "global_position", deal_position - card.get_rect().size, 0.45)\
				.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		
			tween.tween_callback(_on_finished_deal_animation.bind(card, cards, deal_position))


		
func _on_finished_deal_animation(last_card: CardSlot, cards: Array[CardSlot], deal_position: Vector2):
	last_card.visible = true
	card_texture_placeholder.texture = null
	card_texture_placeholder.global_position = global_position
	
	if cards.size() > 0:
		cards.erase(last_card)
		run_deal_animation(cards, deal_position)

	
	