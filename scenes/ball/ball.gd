extends RigidBody2D

@export
var first_impulse_val: int = -10
@export
var force: float = 10
var current_direction = Vector2.ZERO
var did_hit: bool = false
@export
var can_start: bool = false

var counter = 0

@export
var wait_after_reset = false

func _enter_tree() -> void:
	if is_multiplayer_authority():
		set_physics_process(true)
	else:
		visible = false
		set_physics_process(false)

func _physics_process(delta: float) -> void:
	#if wait_after_reset:
		#if $Timer.time_left <= 0:
			#wait_after_reset = false
		#else:
			#return
	if !is_multiplayer_authority():
		return
	if not can_start:
		return
	if not did_hit:
		move_and_collide(Vector2(first_impulse_val,0))
	else:
		move_and_collide(current_direction)
	

func push_away(direction:Vector2):
	did_hit = true
	if direction == Vector2.ZERO:
		current_direction.x = -current_direction.x
		current_direction = -current_direction.normalized()*force
	else:
		current_direction=direction.normalized()*force
		#print(current_direction)
	force += 1 
	print("Force is: ", force)
	if force >= 31:
		force = 31
		
func set_can_start(val:bool):
	can_start = val
	
func reset_force():
	print("Resetting force")
	force = 10
	current_direction = Vector2(1,0)*force
	#$Timer.start(1)
	
