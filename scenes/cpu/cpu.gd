extends CharacterBody2D


const SPEED = 600.0

var frequency = 0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if self.name.to_int() != 1:
		position = Vector2(1800,540)
	else:
		position = Vector2(120,540)

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	var ball = get_tree().get_first_node_in_group("ball")
	# Calculate difference in y positions (float)
	var diff = ball.position.y - self.position.y
	var direction = 0
	# Move paddle towards the ball with a speed limit
	if abs(diff) > 5:  # Deadzone to avoid jitter
		direction = sign(diff)  # 1 if ball is below, -1 if above
	
	# Set velocity accordingly, only vertical movement
	velocity = Vector2(0, direction * SPEED)
	#velocity.y = lerp(velocity.y, direction * SPEED, 0.05)
	move_and_slide()
	if self.name.to_int() == 1:
		if position.x != 120:
			position.x = 120
	else:
		if position.x != 1800:
			position.x = 1800

func push_ball(vector: Vector2, body:Node2D):
	if body.is_in_group("ball") and $Timer.time_left <= 0:
		if self.name.to_int() == 1:
			vector = -vector
		body.push_away(vector)
		$Timer.start(0.05)

func _on_area_0_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,0), body)
		
func _on_area_1_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,0.2), body)

func _on_area_2_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,0.4), body)

func _on_area_3_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,0.6), body)

func _on_area_4_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,-0.2), body)

func _on_area_5_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,-0.4), body)

func _on_area_6_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,-0.6), body)
	
func _on_area_bottom_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,-0.6), body)
	
func _on_area_top_body_entered(body: Node2D) -> void:
	push_ball(Vector2(-1,0.6), body)
	
