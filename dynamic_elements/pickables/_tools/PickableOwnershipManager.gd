extends Node
class_name PickableOwenershipManager

@onready var pickable: XRToolsPickable = get_parent()

func _ready() -> void:
	pickable.grabbed.connect(_on_grabbed)
	pickable.released.connect(_on_released)
	
func _on_released(_pickable, _by):
	give_back_authority.rpc()
	
@rpc("any_peer", "call_local")
func give_back_authority():
	pickable.set_multiplayer_authority(1)
	
func _on_grabbed(_pickable, by):
	if by is XRToolsSnapZone:
		return
	
	var player: Player = XRTools.find_xr_ancestor(by, "*", "XRPlayer")
	
	if !player:
		printerr("Player not found!")
		return
		
	gain_authority.rpc(player.name.to_int())
	
@rpc("any_peer", "call_local")
func gain_authority(id: int):
	pickable.set_multiplayer_authority(id)
