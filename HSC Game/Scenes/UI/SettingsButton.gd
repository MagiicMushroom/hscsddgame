#kevin du 2022
extends Button

#button that brings you to the title screen and back, all the other setting related code is also dumped here.
func _ready():
	if get_tree().current_scene.filename == "res://Scenes/TitleScreen.tscn":
		visible = false
	else:
		visible = true        

func _process(_delta):
	Globals.drawline = get_parent().get_node("TabContainer/Video/CheckBox").pressed
	Globals.god = get_parent().get_node("TabContainer/Other/CheckBox").pressed
	ProjectSettings.set("debug/settings/force_fps", int(get_parent().get_node("TabContainer/Video/Panel/CheckBox").text))

func _on_Button_button_down():
	get_node("/root/Node2D/GUI/UI").transitioning = true

func _on_TabContainer_mouse_entered():
	if visible:
		get_node("/root/Node2D/GUI/UI")._on_WindowDialog_mouse_entered()

func _on_TabContainer_mouse_exited():
	if visible:
		get_node("/root/Node2D/GUI/UI")._on_WindowDialog_mouse_exited()

func _on_Settings_visibility_changed():
	if visible:
		get_node("/root/Node2D/GUI/UI")._on_WindowDialog_popup_hide()