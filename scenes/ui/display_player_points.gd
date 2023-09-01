extends HBoxContainer

@onready var username_label: Label = $Name
@onready var poison_points_label:  Label = $HBoxContainer/PoisonPoints

var poison_points: float = 0.0
var username: String = ""

func _ready():
	username_label.text = username
	poison_points_label.text = str(poison_points)
	poison_points_label.modulate = Color.LIGHT_GREEN
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_delay(1.0)
	
