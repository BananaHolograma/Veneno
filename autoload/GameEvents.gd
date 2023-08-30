class_name GameEvents extends Node

signal card_dropped_in_pile(player: Player, card: PlayingCard, pile: PileSlot)

func emit_card_dropped_in_pile(player, card, pile):
	card_dropped_in_pile.emit(player, card, pile)
