extends XRToolsSceneBase

const PLAYER = preload("res://dynamic_elements/player/Player.tscn")
const MAIN = preload("res://levels/main/main.tscn")

@onready var player: Player = $Player

@export var spawn_parent: Node3D

var start_position: Vector3
var start_rotation: Vector3

func _ready() -> void:
	# Store start position for host to use when joined
	start_position = player.global_position
	start_rotation = player.global_rotation
	
	MultiplayerHandler.player_connected.connect(_on_player_connected)
	MultiplayerHandler.player_disconnected.connect(_on_player_disconnected)
	MultiplayerHandler.server_hosted.connect(_on_server_hosted)
	
	if DisplayServer.get_name() == "headless":
		MultiplayerHandler.host()

# Override default XRToolsSceneBase behavior
func scene_loaded(_user_data = null):
	player.global_rotation = start_rotation
	
func _on_server_hosted():
	# Cleanup the temp player used for UI control
	player.xr_origin.current = false
	player.queue_free()
	
	# Reset host position
	var new_player = spawn_player(multiplayer.get_unique_id())
	new_player.global_position = start_position
	new_player.global_rotation = start_rotation

func _on_player_connected(id: int):
	# Cleanup the temp player used for UI control
	if id == multiplayer.get_unique_id():
		player.queue_free()
		
	spawn_player(id)
	
	if DisplayServer.get_name() == "headless":
		MultiplayerHandler.change_scene.rpc(MAIN.resource_path)
	
func spawn_player(id: int):
	var _player: Player = PLAYER.instantiate()
	spawn_parent.add_child(_player)
	_player.init_multiplayer(id)
	
	return _player
	
func _on_player_disconnected(id: int):
	var child = spawn_parent.get_node(str(id))
	
	if !child:
		print("Could not find child with name %s" % id)
		return
		
	child.queue_free()
