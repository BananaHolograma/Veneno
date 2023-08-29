class_name CardSlot extends TextureRect

@export var player: Player
@export var playing_card: PlayingCard


func _get_drag_data(at_position):
	var preview_card_slot = duplicate()
	preview_card_slot.texture = playing_card.selected_texture.texture
	preview_card_slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview_card_slot.size = playing_card.selected_texture.get_rect().size
	
	var preview = Control.new()
	preview.add_child(preview_card_slot)
	# Size to put the mouse in the center of the preview
#	preview_card_slot.get_rect().size * -0.5
	set_drag_preview(preview)
	modulate.a = 0.2
	return preview_card_slot
	
func _can_drop_data(at_position, data):
	return data is CardSlot and data.playing_card == playing_card and data.player == player
	
	
func _drop_data(at_position, data):
	texture = playing_card.symbol_texture.texture
	modulate.a = 1.0
