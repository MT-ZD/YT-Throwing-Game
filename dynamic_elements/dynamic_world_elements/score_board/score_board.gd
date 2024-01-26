extends Node3D
class_name ScoreBoard

@onready var label: Label = $SubViewport/Control/CenterContainer/Label

func _ready() -> void:
	GameController.register_score_board(self)

func change_score(score):
	var text = ""
	
	for score_value in score:
		text += "%s/" % score_value
	
	label.text = text.substr(0, text.length() - 1)
		
	
