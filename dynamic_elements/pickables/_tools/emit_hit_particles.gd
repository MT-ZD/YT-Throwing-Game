@tool
extends GPUParticles3D
class_name EmitHitParticles

@onready var _pickable : XRToolsPickable = get_parent()

func _ready() -> void:
	_pickable.body_entered.connect(_on_body_entered)
	emitting = false
	
func _on_body_entered(_body):
	if _pickable.is_picked_up():
		return
	
	emitting = true
	

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	if !(get_parent() is XRToolsPickable):
		warnings.append("Not child of XRToolsPickable")

	return warnings
