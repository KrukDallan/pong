extends CharacterBody2D


const SPEED = 500.0

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if self.name.to_int() != 1:
		position = Vector2(1800,540)
	else:
		position = Vector2(120,540)

func _physics_process(delta: float) -> void:
	if is_multiplayer_authority():
		velocity *= delta
		var direction = Vector2.ZERO

		if Input.is_key_pressed(KEY_UP):
			velocity.y = -1
			#direction.y = -1
		elif Input.is_key_pressed(KEY_DOWN):
			velocity.y = 1
			#direction.y = 1
		else:
			velocity.y = 0
			#direction.y = 0
			
		velocity *= SPEED
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
	
@rpc("authority", "call_local")
func update_position(pos):
	global_position = pos
