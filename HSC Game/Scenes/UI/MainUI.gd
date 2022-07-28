#kevin du 2022 dhomya I WILL FINISH THIS GAME IN 4 DAYS
extends Control

var transitioning: bool = false

onready var MI = get_node("MouseIndicator/KillMe")
onready var settings = $Settings
onready var popup = $WindowDialog
onready var inventory = get_node("WindowDialog/Inventory")
onready var scrollcontainer = get_node("WindowDialog/Inventory/MarginContainer/HBoxContainer/PanelContainer/Control/MarginContainer/ColorRect/CenterContainer/ScrollContainer")
onready var itemlist = scrollcontainer.get_node("GridContainer")

#main UI script, responsible for everything UI related like health, inventory, etc
#i predict there is going to be a lot of code here ):

func _init():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _ready():
	transitioning = false
	$ColorRect.visible = true
	$WindowDialog.get_close_button().mouse_filter = 1

func _process(delta):
	#move mouse
	MI.MouseMove()

	#make sure the itemlist is nice and cosy
	var columnsshifted = float(get_node("WindowDialog/Inventory/MarginContainer/HBoxContainer/PanelContainer/Control/MarginContainer").rect_size.x - 10) / 64
	itemlist.columns = floor(columnsshifted)
	scrollcontainer.rect_min_size = get_node("WindowDialog/Inventory/MarginContainer/HBoxContainer/PanelContainer/Control/MarginContainer").rect_size

	get_node("VBoxContainer/Healthbar/TextureProgress").value = Globals.playerhealth
	get_node("VBoxContainer/Staminabar/TextureProgress").value = Globals.playerstamina

	#make screen fade to black if transitioning between screens
	if transitioning:
		$ColorRect.modulate.a = min($ColorRect.modulate.a + (delta/2) * 2.55 , 1)
		if $ColorRect.modulate.a == 1:
			if get_tree().change_scene("res://Scenes/TitleScreen.tscn"):
				pass
	else:
		$ColorRect.modulate.a = max($ColorRect.modulate.a - (delta/2) * 2.55 , 0)
		
#open and close tabs in UI
func _input(_event):
	var event: InputEvent = _event
	if event is InputEventKey and event.is_pressed():
		match event.scancode:
			KEY_E:
				if !settings.visible:
					if popup.visible:
						popup.visible = false
					else:
						popup.popup()
			KEY_ESCAPE:
				popup.visible = false
				settings.visible = !settings.visible
			

func _on_WindowDialog_mouse_entered():
	MI.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_WindowDialog_mouse_exited():
	MI.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_WindowDialog_popup_hide():
	MI.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
