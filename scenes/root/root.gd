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
var counter = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	counter += delta
	if len(get_tree().get_nodes_in_group("Player")) == 2:
		var ball = get_tree().get_first_node_in_group("ball")
		if ball != null:
			ball.can_start = true
		counter = 0
	

func push_ball(vector: Vector2, body:Node2D):
	if body.is_in_group("ball") and $Timer.time_left <= 0:
		body.push_away(vector)
		$Timer.start(0.01)
		
		
func add_player(id=1):
	var player = player_scene.instantiate()
	player.set_multiplayer_authority(id)
	player.name = str(id)
	call_deferred("add_child",player)
	
	print("Adding ball")
	if is_multiplayer_authority():
		add_ball()
	
	$Multiplayer.visible = false
	#print("manage player1: ", manage_player1)
	rpc("show_score")

	
	#if multiplayer.is_server():
		#rpc("add_ball")
	if manage_player1:
		manage_player1 = false
		$Score.visible = true
		
	
func add_ball():
	if len(get_tree().get_nodes_in_group("ball")) < 1:
		var ball = ball_scene.instantiate()
		ball.set_multiplayer_authority(1)  # host usually has peer ID 1
		call_deferred("add_child",ball)
		var balls = get_tree().get_nodes_in_group("ball")
		
	
func reset_ball():
	var ball = get_tree().get_first_node_in_group("ball")
	ball.position = Vector2(960,540)
	ball.can_start = false
	await get_tree().create_timer(1.5).timeout
	ball.reset_force()
	ball.can_start = true

func _on_area_2d_left_body_entered(body: Node2D) -> void:
	$Score.point_p1()
	await reset_ball()

func _on_area_2d_right_body_entered(body: Node2D) -> void:
	$Score.point_p2()
	await reset_ball()
	
func _on_area_2d_top_body_entered(body: Node2D) -> void:
	print(body)
	push_ball(Vector2.ZERO,body)

func _on_area_2d_bottom_body_entered(body: Node2D) -> void:
	print(body)
	push_ball(Vector2.ZERO,body)

@rpc("authority", "call_remote")
func show_score():
	$Score.visible = true
