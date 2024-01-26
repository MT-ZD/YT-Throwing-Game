extends Node3D

@export var spawn_item: PackedScene
@export var spawn_parent: Node3D

@onready var spawn_point: Node3D = $"Spawn Point"
@onready var interactable_area_button: XRToolsInteractableAreaButton = $InteractableAreaButton

func _ready():
	interactable_area_button.button_pressed.connect(_on_button_pressed)

func _on_button_pressed(_button: XRToolsInteractableAreaButton):
	handle_button_pressed.rpc_id(1)

@rpc("any_peer", "reliable", "call_local")
func handle_button_pressed():
	if !multiplayer.is_server():
		return

	var item = spawn_item.instantiate()
	spawn_parent.add_child(item, true)
	item.global_transform = spawn_point.global_transform
