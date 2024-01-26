extends Node

signal server_hosted
signal player_connected(peer_id: int)
signal player_disconnected(peer_id: int)
signal server_disconnected

const PORT := 7777

var players: Array[int] = []

var scene_base: XRToolsSceneBase

func _ready():
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func join(ip: String):
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_client(ip, PORT)
	
	if error:
		printerr(error)
		return error
		
	multiplayer.multiplayer_peer = peer
	
func host():
	var peer = ENetMultiplayerPeer.new()
	
	var error = peer.create_server(PORT, 2)
	
	if error:
		printerr(error)
		return error
		
	server_hosted.emit()
	
	players.append(1)
	
	multiplayer.multiplayer_peer = peer
	print("Hosted")

@rpc("any_peer", "reliable")
func _register_player():
	var new_player_id := multiplayer.get_remote_sender_id()
	player_connected.emit(new_player_id)
	
@rpc("authority", "call_local")
func change_scene(path: String):
	if !scene_base:
		printerr("Scane base not registered")
		return
	
	scene_base.load_scene(path)
	
func register_scene_base(base: XRToolsSceneBase):
	scene_base = base

func _on_player_connected(id: int):
	_register_player.rpc_id(id)
	players.append(id)
	
	print("Player %s connected" % id)

func _on_player_disconnected(id: int):
	players.erase(id)
	player_disconnected.emit(id)
	
	print("Player %s disconnected" % id)

func _on_connected_ok():
	var peer_id := multiplayer.get_unique_id()
	players.append(peer_id)
	player_connected.emit(peer_id)

func _on_connected_fail():
	multiplayer.multiplayer_peer = null

func _on_server_disconnected():
	multiplayer.multiplayer_peer = null
	players.clear()
	server_disconnected.emit()
	
func _exit_tree() -> void:
	multiplayer.multiplayer_peer = null
