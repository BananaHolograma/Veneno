extends HBoxContainer

@onready var username_label: Label = $Name
@onready var poison_points_label:  Label = $HBoxContainer/PoisonPoints

var poison_points: float = 0.0
var username: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	username_label.text = username
	poison_points_label.text = str(poison_points)
	poison_points_label.modulate = Color.LIGHT_GREEN
