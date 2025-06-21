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
	print("Spawning ball")
	if has_node("Ball"): return
	print("Node does not have any ball instantiated, proceding with instantiating it")
	var ball = ball_scene.instantiate()
	ball.name = "Ball"
	ball.set_multiplayer_authority(1)
	call_deferred("add_child",ball)
	if multiplayer.is_server():
		print("Changing linear velocity")
		ball.linear_velocity = Vector2(300, 0)
		
func _on_peer_connected(id: int) -> void:
	print("Peer connected: ", id)

func _on_peer_disconnected(id: int) -> void:
	print("Peer disconnected: ", id)


func _on_host_button_pressed() -> void:
	host()


func _on_join_button_pressed() -> void:
	join("192.168.1.187")
