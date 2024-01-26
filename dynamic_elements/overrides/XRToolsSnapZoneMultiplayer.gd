extends XRToolsSnapZone
class_name XRToolsSnapZoneMultiplayer

# func pick_up(by: Node3D) -> void:
# 	if not is_instance_valid(picked_up_object):
# 		return
	
# 	var ownership_manager: PickableOwenershipManager = picked_up_object.find_child("PickableOwenershipManager")

# 	if !ownership_manager:
# 		return
	
# 	var player: Player = XRTools.find_xr_ancestor(by, "*", "XRPlayer")
	
# 	if !player:
# 		printerr("Player not found!")
# 		return

# 	ownership_manager.gain_authority.rpc(player.name.to_int())
	

func drop_object() -> void:
	handle_drop_object.rpc()

@rpc("any_peer", "reliable", "call_local")
func handle_drop_object():
	if not is_instance_valid(picked_up_object):
		return

	# let go of this object
	picked_up_object.let_go(self, Vector3.ZERO, Vector3.ZERO)
	picked_up_object = null
	has_dropped.emit()
	highlight_updated.emit(self, enabled)
	