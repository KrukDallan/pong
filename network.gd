extends Node2D

@export var ball_scene: PackedScene

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	$MultiplayerSpawner.spawn_path = get_path()

func host():
	var p = ENetMultiplayerPeer.new()
	p.create_server(12345)
	multiplayer.multiplayer_peer = p
	# spawn host player + ball when hosting
	#rpc("spawn_ball")
	#$MultiplayerSpawner.add_spawnable_scene("res://temp/Ball.tscn")
	
func join(ip):
	var p = ENetMultiplayerPeer.new()
	p.create_client(ip, 12345)
	multiplayer.multiplayer_peer = p

		
@rpc("authority", "call_local")
func spawn_ball():
	if has_node("Ball"):
		return  # Prevent double spawn
	var ball
	if multiplayer.is_server():
		pass

	# Host gets authority, clients just sync
	if multiplayer.is_server():
		ball.set_multiplayer_authority(multiplayer.get_unique_id())
	else:
		# Give authority to the host (usually 1)
		ball.set_multiplayer_authority(1)

	call_deferred("add_child",ball)

	# Only the host applies physics
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
