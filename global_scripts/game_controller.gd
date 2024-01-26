extends AudioStreamPlayer

const HIT = preload("res://audio/hit.wav")

var score_board: ScoreBoard
var players: Array[Player]

var score: Dictionary

func _ready() -> void:
	stream = HIT

func register_score_board(_score_board: ScoreBoard):
	score_board = _score_board

func add_player(player: Player):
	score[player] = 0
	
@rpc("any_peer", "call_local")
func kill_player(player: Player, give_points_to: Player):
	print("killing player")
	if !multiplayer.is_server():
		return
		
	player.die.rpc_id(player.name.to_int())
	
	score[give_points_to] += 1
	
	play_sound.rpc()
	
	update_score_board.rpc(score)
	
func sync_score_board():
	if !multiplayer.is_server():
		return
		
	update_score_board.rpc_id(1, score)
	
@rpc("authority", "call_local")
func play_sound():
	playing = true
	
@rpc("authority", "call_local")
func update_score_board(_score: Dictionary):
	score_board.change_score(_score.values())
