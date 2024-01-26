extends Node

@export var staging: XRToolsStaging

func _ready() -> void:
	staging.scene_loaded.connect(_on_scene_loaded)
	
func _on_scene_loaded(scene: XRToolsSceneBase, _user_data):
	MultiplayerHandler.register_scene_base(scene)
