class_name EndGameScreen extends Control


@onready var points: VBoxContainer = $Panel/Points
@onready var display_player_points_scene: PackedScene = preload("res://scenes/ui/display_player_points.tscn")

func _enter_tree():
	modulate.a = 0.0
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1)

func display_result(players: Array = []):
	if is_inside_tree():
		for player in players:
			var display_player_points = display_player_points_scene.instantiate()
			display_player_points.username = player.username
			display_player_points.poison_points = player.total_poison_points()
			points.add_child(display_player_points)
