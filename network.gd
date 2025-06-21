extends Node2D

@export var ball_scene: PackedScene

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func host():
	var p = ENetMultiplayerPeer.new()
	p.create_server(12345)
	multiplayer.multiplayer_peer = p
	# spawn host player + ball when hosting
	spawn_ball()

func join(ip):
	var p = ENetMultiplayerPeer.new()
	p.create_client(ip, 12345)
	multiplayer.multiplayer_peer = p

@rpc("authority", "call_remote")
func spawn_ball():
	if has_node("Ball"): return
	var ball = ball_scene.instantiate()
	ball.name = "Ball"
	ball.set_multiplayer_authority(1)
	add_child(ball)
	if multiplayer.is_server():
		ball.linear_velocity = Vector2(300, 0)
		
func _on_peer_connected(id: int) -> void:
	print("Peer connected: ", id)

func _on_peer_disconnected(id: int) -> void:
	print("Peer disconnected: ", id)


func _on_host_button_pressed() -> void:
	host()


func _on_join_button_pressed() -> void:
	join("192.168.1.187")
