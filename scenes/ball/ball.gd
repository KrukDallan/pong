extends RigidBody2D

@export
var first_impulse_val: int = -10
var force: float = 10
var current_direction = Vector2.ZERO
var did_hit: bool = false
var can_start: bool = false

var counter = 0

func _enter_tree() -> void:
	#set_multiplayer_authority(1)
	if is_multiplayer_authority():
		set_physics_process(true)
	else:
		visible = false
		set_physics_process(false)

	# Physics and collision logic here

func _physics_process(delta: float) -> void:
	counter += delta
	if counter >=1.5:
		#print("is multip auth: ", is_multiplayer_authority())
		#print("is physics processing: ", is_physics_processing())
		counter = 0
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
		print(current_direction)
	force += 1 
	if force >= 31:
		force = 31
		
func set_can_start(val:bool):
	can_start = val
	
