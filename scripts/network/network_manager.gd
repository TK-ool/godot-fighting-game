extends Node

const SERVER_PORT: int = 8080

var _is_host: bool = false

#creates a server for clients to connect to
func create_server():
	_is_host = true
	var enet_network_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	enet_network_peer.create_server(SERVER_PORT)
	get_tree().get_multiplayer().multiplayer_peer = enet_network_peer
	print("Server created!")

#connects to the specified server
func create_client(host_ip: String = "localhost", host_port: int = SERVER_PORT):
	_is_host = false
	_setup_client_connection_signals()
	
	var enet_network_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	enet_network_peer.create_client(host_ip, host_port)
	get_tree().get_multiplayer().multiplayer_peer = enet_network_peer
	print("Client created!")

#connects disconnection signal if not already connected
func _setup_client_connection_signals():
	if not get_tree().get_multiplayer().server_disconnected.is_connected(_server_disconnected):
		get_tree().get_multiplayer().server_disconnected.connect(_server_disconnected)

#Fires when signal sees that host disconnects
func _server_disconnected():
	print("Server Disconnected")
	terminate_connection()

#if main menu available make here
func load_game_scene():
	pass
	
func terminate_connection():
	get_tree().get_multiplayer().multiplayer_peer = null
	_disconnect_client_connection_signals()
	print("Connection Terminated")
	
func _disconnect_client_connection_signals():
	if get_tree().get_multiplayer().server_disconnected.has_connections():
		get_tree().get_multiplayer().server_disconnected.disconnect(_server_disconnected)
