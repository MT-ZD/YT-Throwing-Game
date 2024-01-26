extends Node
class_name KillPlayerOnCollision

@onready var pickable: XRToolsPickable = $".."

var last_held_by: Player

func _ready() -> void:
	pickable.body_entered.connect(_on_body_entered)
	pickable.grabbed.connect(_on_grabbed)
	
func _on_grabbed(_pickable: XRToolsPickable, by: Variant):
	print("Grabbed by", by, by.get_parent().get_parent())
	var player = XRTools.find_xr_ancestor(by, "*", "XRPlayer")
	
	if player:
		print("setting grabbed by", player, player.get_path())
		set_last_held_by.rpc(player.get_path())
		
@rpc("any_peer", "call_local")
func set_last_held_by(path: String):
	print("RPC setting grabbed by", path)
	last_held_by = get_node(path)
	
func _on_body_entered(body: Node):
	if body is Head:
		print("Collided with head!", last_held_by)
		
	if body is Head and last_held_by and last_held_by != body.player:
		print("Sending kill player")
		GameController.kill_player.rpc_id(1, body.player, last_held_by)
		get_parent().queue_free()
		
