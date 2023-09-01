extends Label


func _ready():
	var tween = create_tween()
	tween.tween_property(self, "global_position:y",  global_position.y - 20, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(queue_free)
