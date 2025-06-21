extends Control

var p1_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func point_p1():
	p1_score += 1
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer2/MarginContainer/Score1.text = str(p1_score) 
