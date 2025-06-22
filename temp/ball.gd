extends CharacterBody2D

const SPEED = 500.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
