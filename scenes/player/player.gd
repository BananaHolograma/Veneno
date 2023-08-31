class_name Player extends Node2D

const GROUP_NAME = "players"

var is_human: bool = true
var table_position: int = 0
var cards_in_hand: Array[PlayingCard] = []
var collected_cards: Array[PlayingCard] = []
var username: String

var random_number_generator: RandomNumberGenerator = RandomNumberGenerator.new()


func _enter_tree():
	if not is_in_group(GROUP_NAME):
		add_to_group(GROUP_NAME)


func suits_available_for_drop() -> Array:
	return cards_in_hand.filter(func(card: PlayingCard): return not card.suit.is_empty() and not card.is_poison)\
		.map(func(card: PlayingCard): return card.suit)


func poison_cards_in_hand() -> Array[PlayingCard]:
	return cards_in_hand.filter(func(card: PlayingCard): return card.is_poison)


func normal_cards_in_hand() -> Array[PlayingCard]:
	return cards_in_hand.filter(func(card: PlayingCard): return not card.is_poison)
	
	
func collect_cards(cards: Array[PlayingCard]):
	collected_cards.append_array(cards)


func execute_robot_movement():
	if not cards_in_hand.is_empty() and not is_human:	
		var decision_tree = _prepare_decision_tree()
		
		# When the table is empty put random normal card in there always first
		if decision_tree["empty_piles"].size() == decision_tree["piles"].size():
			_drop_normal_card_in_empty_pile(decision_tree)
		else:
			if decision_tree["piles_with_suit"].keys().size() > 0:
				if decision_tree["allowed_suits_to_drop_cards"].size() > 0:
						if _decides_to_use_poison(decision_tree):
							_drop_poison_card_in_pile(decision_tree)
						else:
							_drop_normal_card_in_pile(decision_tree)
				
				elif decision_tree["empty_piles"].size() > 0:
					_drop_normal_card_in_empty_pile(decision_tree)
				else:
					_drop_poison_card_in_pile(decision_tree)
					

func _prepare_decision_tree() -> Dictionary:
	var decision_tree: Dictionary = {
		 "piles": get_tree().get_nodes_in_group("piles") as Array[PileSlot],
		 "empty_piles": [],
		 "piles_with_suit": {},
		 "normal_cards": normal_cards_in_hand() as Array[PlayingCard],
		 "poison_cards": poison_cards_in_hand() as Array[PlayingCard],
		 "allowed_suits_to_drop_cards": []
	}

	decision_tree["empty_piles"] = decision_tree["piles"].filter(func(pile: PileSlot): return pile.current_suit.is_empty()) as Array[PileSlot]
	
	for pile in decision_tree["piles"].filter(func (pile: PileSlot): return pile not in decision_tree["empty_piles"]):
		decision_tree["piles_with_suit"][pile.current_suit] = { "pile": pile, "cards_to_drop": []}
	
	for normal_card in decision_tree["normal_cards"]:
		if decision_tree["piles_with_suit"].has(normal_card.suit):
			decision_tree["piles_with_suit"][normal_card.suit]["cards_to_drop"].append(normal_card)
			if not decision_tree["allowed_suits_to_drop_cards"].has(normal_card.suit):
				decision_tree["allowed_suits_to_drop_cards"].append(normal_card.suit)
	
	return decision_tree
	

func _drop_normal_card_in_pile(decision_tree: Dictionary) -> void:
	if decision_tree["piles_with_suit"].keys().size() > 0:
		var selected_pile_data = decision_tree["piles_with_suit"].values().filter(func(data): return data["cards_to_drop"].size() > 0).pick_random()
		var selected_pile = selected_pile_data["pile"] as PileSlot
		selected_pile.drop_card_in_pile(self, selected_pile_data["cards_to_drop"].pick_random())

			
func _drop_normal_card_in_empty_pile(decision_tree: Dictionary) -> void:
	var selected_pile = decision_tree["empty_piles"].pick_random() as PileSlot
	selected_pile.drop_card_in_pile(self, decision_tree["normal_cards"].pick_random())


func _drop_poison_card_in_pile(decision_tree: Dictionary) -> void:
	if decision_tree["poison_cards"].size() > 0 and decision_tree["piles_with_suit"].keys().size() > 0:
		var selected_pile = decision_tree["piles_with_suit"].values().pick_random()["pile"]
		selected_pile.drop_card_in_pile(self, decision_tree["poison_cards"].pick_random())


func _decides_to_use_poison(decision_tree: Dictionary) -> bool:
	if decision_tree["poison_cards"].size() > 0 and decision_tree["piles_with_suit"].keys().size() > 0:
		return random_number_generator.randf_range(0.0, 0.1) < 0.25
	else:
		return false
