class_name MenuBackground extends TextureRect

@onready var background_one = preload("res://assets/background/Battleground1.png")
@onready var background_two = preload("res://assets/background/ruins.png")
@onready var background_three = preload("res://assets/background/Battleground4.png")

var random_number_generator = RandomNumberGenerator.new()

func _ready():
	var random_background = random_number_generator.randi_range(0, 1)
	var selected_background = background_three
	
	match(random_number_generator.randi_range(0, 2)):
		0:
			selected_background = background_one
		1:
			selected_background = background_two
		2:
			selected_background = background_three
	
	texture = selected_background
	expand_mode = TextureRect.EXPAND_FIT_WIDTH
	size = get_viewport().get_visible_rect().size
