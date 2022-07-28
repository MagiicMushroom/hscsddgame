#kevin du 2022 this one is a long boy
extends GridContainer

var pickeditem = null
var pickedlocation = null
var mouseover = false
var mousepressed = false
var anytrue = false

#load itemslot and itemnodes, which are templates used in the inventory
onready var itemslot = preload("res://Scenes/UI/Inventory/ItemSlot.tscn")
onready var itemnode = preload("res://Scenes/UI/Inventory/Item.tscn")

#on ready make x amount of inventory slots
func _ready():
	for x in range(0,Globals.maxinvsize):
		add_child(itemslot.instance())
		get_child(x).slotnumber = x

func _process(_delta):
	#if picked item, make it follow mouse
	if pickeditem != null:
		pickeditem.global_position = get_global_mouse_position()
	#is the mouse over the inventory?
	if (abs(get_local_mouse_position().x - find_parent("Inventory").rect_size.x/2) < find_parent("Inventory").rect_size.x/2) and (abs(get_local_mouse_position().y - find_parent("Inventory").rect_size.y/2) < find_parent("Inventory").rect_size.y/2):
		mouseover = true
	else:
		mouseover = false

#when the mouse is clicked
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.is_pressed():
			mousepressed = true
		elif event.button_index == BUTTON_LEFT:
			mousepressed = false
	
	#check if the mouse is over any inventory slot
	anytrue = false
	for x in range(0,Globals.maxinvsize):
		if get_child(x).mouseover:
			anytrue = true
	
	# if the mouse isn't over the inventory or it is released when not over a slot, the item is placed into the first vacant slot.
	if !mouseover or (!anytrue and !mousepressed):
		if pickeditem != null:
			for x in range(0,Globals.maxinvsize):
				if get_child(x).get_child_count() == 0:
					get_child(x).putintoslot(pickeditem)
					Inventory.inventory[get_child(x).slotnumber] = Inventory.inventory[pickedlocation.slotnumber]
					break
			pickeditem = null
			pickedlocation = null	

#function called by Inventory.gd, to update the inventory when new items are picked up.
func inventoryupdate():
	for x in Inventory.inventory:
		var i = itemnode.instance()
		if get_child(x).get_child_count() == 0:
			get_child(x).add_child(i)
			get_child(x).i = i
			i.get_node("Sprite").texture = load(Inventory.inventory[x]["itemsprite"])
			get_child(x).refreshstyle()

#swapping items in the inventory
func inventoryswitch(slot, item, pickup):
	if pickup:
		if pickeditem == null:
			if item != null:
				pickeditem = slot.pickfromslot()
				pickedlocation = slot
	else:
		if item == null:
			if pickeditem != null:
				slot.putintoslot(pickeditem)
				pickeditem = null
				Inventory.inventory[slot.slotnumber] = Inventory.inventory[pickedlocation.slotnumber]
				Inventory.inventory.erase(pickedlocation.slotnumber)
		else:
			if pickeditem != null:
				item = slot.pickfromslot()
				slot.putintoslot(pickeditem)
				pickeditem = null
				pickedlocation.putintoslot(item)
				var temp = Inventory.inventory[slot.slotnumber]
				Inventory.inventory[slot.slotnumber] = Inventory.inventory[pickedlocation.slotnumber]
				Inventory.inventory[pickedlocation.slotnumber] = temp
		pickedlocation = null

func _on_GridContainer_mouse_exited():
	pass
