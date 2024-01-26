extends Node3D

# Would love this to have a class_name to get proper hinting
@onready var viewport_2_din_3d: Node3D = $Viewport2Din3D

@onready var virtual_keyboard: Node3D = $VirtualKeyboard

func _ready() -> void:
	viewport_2_din_3d.connect_scene_signal("needs_keyboard", _on_needs_keyboard)
	viewport_2_din_3d.connect_scene_signal("can_close_keyboard", _on_can_close_keyboard)

func _on_needs_keyboard():
	virtual_keyboard.visible = true

func _on_can_close_keyboard():
	virtual_keyboard.visible = false
