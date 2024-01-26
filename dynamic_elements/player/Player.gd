extends Node3D
class_name Player

@export var force_local = false
@export var can_move = false

@export var spawn_position: Vector3
@export var spawn_rotation: Vector3
@export var right_hand_model: XRToolsHand
@export var right_controller: XRController3D
@export var left_hand_model: XRToolsHand
@export var xr_origin: XROrigin3D
@export var xr_camera_3d: XRCamera3D
@export var movement_controllers: Array[XRToolsMovementProvider]
@export var head_meshes: Array[VisualInstance3D]
@export var remote_transforms: Array[RemoteTransform3D]
@export var player_body: XRToolsPlayerBodyMultiplayer

var id: int
var is_local = false

func is_xr_class(name : String) -> bool:
	return name == "XRPlayer"

func _enter_tree() -> void:
	if force_local:
		setup_local_player()

func _ready() -> void:
	if !can_move:
		for controller in movement_controllers:
			controller.enabled = false
			
	right_controller.button_pressed.connect(_on_button_pressed)
	
func init_multiplayer(_id: int):
	id = _id
	
	# Set the Player name to its id to make it easy to find
	name = str(id)
	
	set_multiplayer_authority(id)
	
	if id == multiplayer.get_unique_id():
		setup_local_player()
		return
		
	setup_remote_player()
		

# Hides player model and enables local control
func setup_local_player():
	right_hand_model.visible = false
	left_hand_model.visible = false
	xr_origin.current = true
	xr_camera_3d.current = true
	xr_origin.process_mode = Node.PROCESS_MODE_INHERIT
	xr_origin.world_scale = 0.8
	is_local = true
	
	for instance in head_meshes:
		instance.set_layer_mask_value(1, false)
		instance.set_layer_mask_value(2, true)
		
func _on_button_pressed(_name: String) -> void:
	if !is_local:
		return
		
	if _name == "by_button":
		player_body.player_calibrate_height = true
		
# Sets up dummy player controlled remotely and disables local control
func setup_remote_player():
	xr_origin.current = false
	xr_origin.visible = false
	xr_origin.set_process(false)
	is_local = false
	
	# Event tho the parent has disabled processing, you need to disable this
	for r_transform in remote_transforms:
		r_transform.update_position = false
		r_transform.update_rotation = false
		r_transform.update_scale = false

@rpc("call_local", "any_peer", "reliable")
func die():
	xr_origin.position = spawn_position
	xr_origin.rotation = spawn_rotation
