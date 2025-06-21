extends RigidBody2D

@export
var first_impulse_val: int = 10
var force: float = 10
var current_direction = Vector2.ZERO
var did_hit: bool = false
var can_start: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	can_start= true
	#self.apply_impulse(Vector2(first_impulse_val,0), Vector2(0,0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
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
	
