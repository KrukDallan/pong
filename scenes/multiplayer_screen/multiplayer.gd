extends Node2D

var peer = ENetMultiplayerPeer.new()

@export
var player_scene: PackedScene

func _ready() -> void:
	print(self.get_owner())
	#$MultiplayerSpawner.spawn_path = self.get_owner().get_path()
	

func _on_host_pressed() -> void:
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(self.get_owner().add_player)
	self.get_owner().add_player()

func _on_join_pressed() -> void:
	peer.create_client("192.168.1.187",1027)
	multiplayer.multiplayer_peer = peer

	
func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)
	
func del_player(id):
	rpc("_del_player",id)

@rpc("any_peer","call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
