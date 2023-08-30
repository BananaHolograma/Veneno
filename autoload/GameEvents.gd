class_name GameEvents extends Node

signal card_dropped_in_pile(player: Player, card: PlayingCard, pile: PileSlot)
signal picked_card_from_deck(player: Player, card: PlayingCard)


func emit_card_dropped_in_pile(player: Player, card: PlayingCard, pile: PileSlot):
	card_dropped_in_pile.emit(player, card, pile)

func emit_picked_card_from_deck(player: Player, card: PlayingCard):
	picked_card_from_deck.emit(player, card)
