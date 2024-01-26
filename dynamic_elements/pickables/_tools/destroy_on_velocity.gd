@tool
extends Node
class_name DestroyOnVelocity

@export var destroy_on_velocity: float = 4
@export var mesh_node: Node3D

@onready var _pickable: XRToolsPickable = get_parent()

var has_particles = false
var wait_for = 0

func _ready() -> void:
	_pickable.body_entered.connect(_on_body_entered)
	
	for child in _pickable.get_children():
		if(child is EmitHitParticles):
			has_particles = true
			wait_for = child.lifetime

func _on_body_entered(_body):
	if _pickable.is_picked_up() || !is_multiplayer_authority():
		return
		
	if _pickable.linear_velocity.length() > destroy_on_velocity:
		if has_particles:
			await before_destruction()
		
		destory_object.rpc()
		
@rpc("authority", "call_local")
func destory_object():
	_pickable.queue_free()
	
func before_destruction():
	_pickable.freeze = true
	mesh_node.visible = false
	
	await get_tree().create_timer(wait_for).timeout
	
func _validate_property(_property: Dictionary) -> void:
	update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if !(get_parent() is XRToolsPickable):
		warnings.append("Not child of XRToolsPickable")
		
	if mesh_node == null && has_particles:
		warnings.append("Missing mesh")

	return warnings
