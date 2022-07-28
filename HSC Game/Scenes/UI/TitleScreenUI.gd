#kevin du 2022
extends CanvasLayer

var transitioning: bool = false

onready var settings = get_node("Control/Settings")

#some settings for setting sets setting set set
func _ready():
	OS.min_window_size = Vector2(1024, 600)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control/ColorRect.visible = true
	transitioning = false
	if Globals.win:
		$Control/TextureRect3.visible = true

#same thing as in main ui, make screen fade to black if transitioning between screens
func _process(delta):
	if transitioning:
		get_node("Control/ColorRect").modulate.a = min(get_node("Control/ColorRect").modulate.a + (delta/2) * 2.55 , 1)
		if get_node("Control/ColorRect").modulate.a == 1:
			get_tree().change_scene("res://Scenes/World.tscn")
	else:
		get_node("Control/ColorRect").modulate.a = max(get_node("Control/ColorRect").modulate.a - (delta/2) * 2.55 , 0)

#open and close tabs
func _input(_event):
	var event: InputEvent = _event
	if event is InputEventKey and event.is_pressed():
		match event.scancode:
			KEY_ESCAPE:
				_on_SettingsButton_pressed()

#button handlers
func _on_StartButton_pressed():
	transitioning = true
	Globals.win = false
	Globals.keygot = false
	Globals.finalbossstart = false

func _on_SettingsButton_pressed():
	settings.visible = !settings.visible

func _on_TutorialButton_pressed():
	$Control/TextureRect1.visible = !$Control/TextureRect1.visible

func _on_CreditsButton_pressed():
	$Control/TextureRect2.visible = !$Control/TextureRect2.visible

func _on_QuitButton_pressed():
	get_tree().quit()

func _on_CloseButton_pressed():
	$Control/TextureRect3.visible = false
