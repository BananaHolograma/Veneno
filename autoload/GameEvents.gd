class_name GameEvents extends Node

signal card_dropped_in_pile(player: Player, card: PlayingCard, pile: PileSlot)
signal pile_collected(player: Player, cards: Array[PlayingCard], pile: PileSlot)
signal picked_card_from_deck(player: Player, card: PlayingCard)
signal emptied_deck(player: Player)

func emit_emptied_deck(player: Player):
	emptied_deck.emit(player)

func emit_card_dropped_in_pile(player: Player, card: PlayingCard, pile: PileSlot):
	card_dropped_in_pile.emit(player, card, pile)

func emit_pile_collected(player: Player, cards: Array[PlayingCard], pile: PileSlot):
	pile_collected.emit(player, cards, pile)

func emit_picked_card_from_deck(player: Player, card: PlayingCard):
	picked_card_from_deck.emit(player, card)
