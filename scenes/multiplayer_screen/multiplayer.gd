extends Node2D

var peer = ENetMultiplayerPeer.new()

@export
var player_scene: PackedScene

func _ready() -> void:
	print(self.get_owner())
	#$MultiplayerSpawner.spawn_path = self.get_owner().get_path()
	


func _process(delta: float) -> void:
	if $TextEdit.has_focus():
		if Input.is_action_just_pressed("ui_accept"):
			get_viewport().set_input_as_handled()
			
	if Input.is_action_just_pressed("ui_accept"):
		if $TextEdit.text != "":	
			var user_ip: String = $TextEdit.text
			user_ip = user_ip.strip_escapes()
			#"192.168.1.187"
			print(user_ip,"ciao","ciao")
			multiplayer.multiplayer_peer.close()
			peer.create_client(user_ip,1027)
			multiplayer.multiplayer_peer = peer

func _on_host_pressed() -> void:
	peer.create_server(1027)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(self.get_owner().add_player)
	self.get_owner().add_player()

func _on_join_pressed() -> void:
	$Search.visible = true
	$TextEdit.visible = true
	$TextEdit.grab_focus()

	
func _on_search_pressed() -> void:
	var user_ip: String = $TextEdit.text
	user_ip.replace("\n","")
	#"192.168.1.187"
	print(user_ip)
	multiplayer.multiplayer_peer.close()
	peer.create_client(user_ip,1027)
	multiplayer.multiplayer_peer = peer

	
func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)
	
func del_player(id):
	rpc("_del_player",id)

@rpc("any_peer","call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
