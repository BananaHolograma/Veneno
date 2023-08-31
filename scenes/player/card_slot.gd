class_name CardSlot extends TextureRect

@export var player: Player
@export var playing_card: PlayingCard


func _notification(what):
	if is_inside_tree():
		match(what):
			NOTIFICATION_MOUSE_ENTER:
				hover_animation(-20.0)
			NOTIFICATION_MOUSE_EXIT:
				hover_animation(0.0)


func _get_drag_data(_at_position):
	if player_can_interact():
		z_index = 10
		var preview_card_slot = duplicate()
		preview_card_slot.texture = playing_card.selected_texture.texture
		preview_card_slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview_card_slot.size = playing_card.selected_texture.get_rect().size
		
		var preview = Control.new()
		preview.name = playing_card.card_name
		preview.add_child(preview_card_slot)
		preview.tree_exited.connect(on_preview_finished)
		# Size to put the mouse in the center of the preview
	#	preview_card_slot.get_rect().size * -0.5
		set_drag_preview(preview)
		modulate.a = 0.2

		return preview_card_slot


func _can_drop_data(_at_position, data):
	return data is CardSlot and data.playing_card == playing_card and data.player == player
	
	
func _drop_data(_at_position, _data):
	texture = playing_card.symbol_texture.texture
	modulate.a = 1.0


func hover_animation(final_position: float):
	if player_can_interact():
		var tween = create_tween()
		tween.tween_property(self, "position:y", final_position, 0.5).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)


func player_can_interact() -> bool:
	return player.is_human

func on_preview_finished():
	modulate.a = 1.0
