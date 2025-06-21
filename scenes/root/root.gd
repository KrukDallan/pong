extends Node2D


#TODO: creare nella scena root i bottoni per hostare o joinare e lo spawner.
#      aggiungere le altre cose necessarie, tipo lo sfondo nero e i bottoni.
#      impostare le posizioni di spawn dei giocatori (posizioni fisse)
#      mettere i punteggi e la distinzione P1 e P2

@export
var player_scene: PackedScene
@export
var ball_scene: PackedScene
@export
var manage_player1 = true
var ball_managed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func push_ball(vector: Vector2, body:Node2D):
	if body.is_in_group("ball") and $Timer.time_left <= 0:
		body.push_away(vector)
		$Timer.start(0.01)
		
		
func add_player(id=1):
	var player = player_scene.instantiate()
	player.set_multiplayer_authority(id)
	$Ball.set_multiplayer_authority(1)
	player.name = str(id)
	call_deferred("add_child",player)
	$Multiplayer.visible = false
	$Ball.visible = true
	#print("manage player1: ", manage_player1)
	rpc("show_score")
	print("Adding ball")
	
	#if multiplayer.is_server():
		#rpc("add_ball")
	if manage_player1:
		position_player1(player)
		manage_player1 = false
		$Score.visible = true
		
func position_player1(player):
	player.position = Vector2(120,540)
	

@rpc("authority", "call_remote")
func add_ball():
	var ball = ball_scene.instantiate()
	ball.set_multiplayer_authority(1)  # host usually has peer ID 1
	call_deferred("add_child",ball)

func _on_area_2d_left_body_entered(body: Node2D) -> void:
	print("Left wall was hit by:", body)
	#push_ball(Vector2(1,0), body)
	# make ball spawn in the middle and push here in a random direction
	# then update the score

func _on_area_2d_right_body_entered(body: Node2D) -> void:
	print("Right wall was hit by:", body)
	#push_ball(Vector2(1,0), body)
	# make ball spawn in the middle and push here in a random direction
	# then update the score
	
func _on_area_2d_top_body_entered(body: Node2D) -> void:
	print(body)
	push_ball(Vector2.ZERO,body)

func _on_area_2d_bottom_body_entered(body: Node2D) -> void:
	print(body)
	push_ball(Vector2.ZERO,body)

@rpc("authority", "call_remote")
func show_score():
	$Score.visible = true
