extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func push_ball(vector: Vector2, body:Node2D):
	if body.is_in_group("ball") and $Timer.time_left <= 0:
		body.push_away(vector)
		$Timer.start(0.01)


func _on_area_2d_left_body_entered(body: Node2D) -> void:
	print("Left wall was hit by:", body)
	push_ball(Vector2(1,0), body)

func _on_area_2d_top_body_entered(body: Node2D) -> void:
	print(body)
	push_ball(Vector2.ZERO,body)

func _on_area_2d_bottom_body_entered(body: Node2D) -> void:
	print(body)
	push_ball(Vector2.ZERO,body)
