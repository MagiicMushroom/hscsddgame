#kevin du 2022 https://www.youtube.com/watch?v=FHYb63ppHmk&list=PLY1jY0hbmKxBvcEHa0k5Aw8_MKoB6jrRU&index=2
extends Panel

var fullstyle: StyleBoxTexture = preload("res://Resources/Shaders/StyleBoxes/SlotFull.tres")
var emptystyle: StyleBoxTexture = preload("res://Resources/Shaders/StyleBoxes/SlotEmpty.tres")
var i = null
var slotnumber
var mouseover = false
var mousepressed = false

func _ready():
	if name == "MainWeapon":
		slotnumber = Globals.maxinvsize + 1
	if name == "OffhandWeapon":
		slotnumber = Globals.maxinvsize + 2
	refreshstyle()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			mousepressed = true
		elif event.button_index == BUTTON_LEFT:
			mousepressed = false
		if mouseover:
			if mousepressed:
				find_parent("Inventory").find_node("GridContainer").inventoryswitch(self,i,true)
			else:
				find_parent("Inventory").find_node("GridContainer").inventoryswitch(self,i,false)

func _process(_delta):
	if (abs(get_local_mouse_position().x - 32) < 32) and (abs(get_local_mouse_position().y - 32) < 32):
		mouseover = true
	else:
		mouseover = false
	if name == "MainWeapon" and Inventory.inventory.has(slotnumber):
		Globals.selectedweapon = Inventory.inventory[slotnumber]["item"]
	else:
		Globals.selectedweapon = null
	if name == "OffhandWeapon" and Inventory.inventory.has(slotnumber):
		Globals.offhandweapon = Inventory.inventory[slotnumber]["item"]
	else:
		Globals.offhandweapon = null
	get_node("/root/Node2D/YSort/Player/Inventory/WeaponController").switchweapons()
	

func refreshstyle():
	if i != null:
		set("custom_styles/panel", fullstyle)
	else:
		set("custom_styles/panel", emptystyle)

func pickfromslot():
	var v = i
	remove_child(i)
	find_parent("Inventory").add_child(i)
	i = null
	refreshstyle()
	return(v)

func putintoslot(newitem):
	i = newitem
	i.position = Vector2.ZERO
	find_parent("Inventory").remove_child(i)
	add_child(i)
	refreshstyle()
