extends Node

const PLAYER = preload("res://dynamic_elements/player/Player.tscn")

@export var base_scene: XRToolsSceneBaseMultiplayer
@export var spawn_point_parent: Node3D
@export var player_parent: Node3D

func _ready():
	if multiplayer.is_server():
		distribute_players()
		
		await get_tree().create_timer(5).timeout
		
		GameController.sync_score_board()
		

func distribute_players():
	var index = 0
	
	for player in MultiplayerHandler.players:
		spawn_player.rpc(player, index)
		index += 1
		
@rpc("authority", "call_local", "reliable")
func spawn_player(id: int, index: int):
	var spawn_point: Node3D = spawn_point_parent.get_child(index)
		
	var instance: Player = PLAYER.instantiate()
	
	instance.can_move = true
	
	player_parent.add_child(instance)
	
	instance.init_multiplayer(id)
	
	instance.global_position = spawn_point.global_position
	instance.global_rotation = spawn_point.global_rotation
	instance.player_body.player_calibrate_height = true
	
	GameController.add_player(instance)
