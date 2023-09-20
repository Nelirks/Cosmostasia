extends Node

signal send_message(msg : String)
signal connection_failed()
signal connection_done()

func _ready() -> void : 
	_connect_signals()

func _connect_signals() -> void :
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.connection_failed.connect(_on_connection_fail)
	multiplayer.connected_to_server.connect(_on_server_joined)

func _disconnect_signals() -> void :
	multiplayer.peer_connected.disconnect(_on_peer_connected)
	multiplayer.connection_failed.disconnect(_on_connection_fail)
	multiplayer.connected_to_server.disconnect(_on_server_joined)

func _on_peer_connected(_id : int) -> void :
	send_message.emit("Peer connected")
	if multiplayer.is_server() :
		rpc("_connection_done")

func _on_connection_fail() -> void :
	send_message.emit("Connection failed")

func _on_server_joined() -> void :
	send_message.emit("Connected to server")

func create_client(ip : String, port : String) -> void :
	if not port.is_valid_int() or int(port) <= 1024 :
		send_message.emit("Invalid port")
		return
	
	var peer : ENetMultiplayerPeer
	emit_signal("send_message", "Joining...")
	peer = ENetMultiplayerPeer.new()
	if peer.create_client(ip, int(port)) :
		send_message.emit("Client creation failed")
		return
	else :
		multiplayer.multiplayer_peer = peer
		multiplayer.multiplayer_peer.set_target_peer(ENetMultiplayerPeer.TARGET_PEER_SERVER)
		return

func create_server(port : String) -> void :
	if not port.is_valid_int() or int(port) <= 1024 :
		send_message.emit("Invalid port")
		connection_failed.emit()
		return
	
	send_message.emit("Creating server...")
	var peer : ENetMultiplayerPeer
	send_message.emit("Hosting...")
	peer = ENetMultiplayerPeer.new()
	if peer.create_server(int(port), 1) :
		send_message.emit("Server creation failed")
		connection_failed.emit()
	else :
		multiplayer.multiplayer_peer = peer
		send_message.emit("Server creation successful")

@rpc("call_local")
func _connection_done() -> void :
	connection_done.emit()
