extends Control
class_name LobbyUI

signal needs_keyboard
signal can_close_keyboard

const MAIN = preload("res://levels/main/main.tscn")

@onready var start_options: HBoxContainer = $CenterContainer/StartOptions
@onready var host_options: VBoxContainer = $CenterContainer/HostOptions
@onready var join_options: VBoxContainer = $CenterContainer/JoinOptions
@onready var start_game: HBoxContainer = $CenterContainer/StartGame

@onready var start_host_btn: Button = $CenterContainer/StartOptions/StartHostBtn
@onready var start_join_btn: Button = $CenterContainer/StartOptions/StartJoinBtn

@onready var back_btn_1: Button = $CenterContainer/HostOptions/HBoxContainer/BackBtn1
@onready var back_btn_2: Button = $CenterContainer/JoinOptions/HBoxContainer/BackBtn2

@onready var host_btn: Button = $CenterContainer/HostOptions/HBoxContainer/HostBtn
@onready var join_btn: Button = $CenterContainer/JoinOptions/HBoxContainer/JoinBtn
@onready var start_game_btn: Button = $CenterContainer/StartGame/StartGameBtn
@onready var ip_input: LineEdit = $CenterContainer/JoinOptions/IPInput

func _ready():
	start_host_btn.pressed.connect(func():
		start_options.visible = false
		host_options.visible = true
	)
	
	start_join_btn.pressed.connect(func():
		start_options.visible = false
		join_options.visible = true	
		needs_keyboard.emit()
	)
	
	back_btn_1.pressed.connect(_on_back)
	back_btn_2.pressed.connect(_on_back)
	
	host_btn.pressed.connect(func(): 
		MultiplayerHandler.host()
		host_options.visible = false
		start_game.visible = true
	)
	
	join_btn.pressed.connect(func(): 
		if ip_input.text.is_empty():
			return 
			
		MultiplayerHandler.join(ip_input.text)
		visible = false
		can_close_keyboard.emit()
	)
	
	start_game_btn.pressed.connect(func():
		MultiplayerHandler.change_scene.rpc(MAIN.resource_path)
	)
	
func _on_back():
	host_options.visible = false
	join_options.visible = false
	start_options.visible = true
	can_close_keyboard.emit()
	
# --- Debugging only ---
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("host_game"):
		MultiplayerHandler.host()
		start_options.visible = false
		start_game.visible = true
		
	if event.is_action_pressed("join_game"):
		if ip_input.text.is_empty():
			return 
			
		MultiplayerHandler.join(ip_input.text)
		visible = false
	
	if event.is_action_pressed("start_game"):
		MultiplayerHandler.change_scene.rpc(MAIN.resource_path)
