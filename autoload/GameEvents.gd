class_name GameEvents extends Node

signal turn_started(player: Player)
signal turn_finished(player: Player)
signal card_dropped_in_pile(player: Player, card: PlayingCard, pile: PileSlot)
signal pile_collected(player: Player, cards: Array[PlayingCard], pile: PileSlot)
signal picked_card_from_deck(player: Player, card: PlayingCard)
signal emptied_deck(player: Player)

func emit_emptied_deck(player: Player) -> void:
	emptied_deck.emit(player)


func emit_card_dropped_in_pile(player: Player, card: PlayingCard, pile: PileSlot) -> void:
	card_dropped_in_pile.emit(player, card, pile)


func emit_pile_collected(player: Player, cards: Array[PlayingCard], pile: PileSlot) -> void:
	pile_collected.emit(player, cards, pile)


func emit_picked_card_from_deck(player: Player, card: PlayingCard) -> void:
	picked_card_from_deck.emit(player, card)


func emit_turn_started(player: Player) -> void:
	turn_started.emit(player)
	
func emit_turn_finished(player: Player) -> void:
	turn_finished.emit(player)
