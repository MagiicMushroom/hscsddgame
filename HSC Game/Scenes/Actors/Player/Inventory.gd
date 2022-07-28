#kevin du 2022 please i need sleep
extends Node2D

onready var player = get_parent()
var itemlist

func _enter_tree():
	itemlist = get_parent().get_node("/root/Node2D/GUI/UI/WindowDialog/Inventory/MarginContainer/HBoxContainer/PanelContainer/Control/MarginContainer/ColorRect/CenterContainer/ScrollContainer/GridContainer")

var inventory = {}

#used to manage inventory, when another script (e.g chest, ground picup, etc) calls GetItem this script just appends the item picked up to the global Inventory.inventory
func GetItem(item):
	for i in range(Globals.maxinvsize):
		if !Inventory.inventory.has(i):
			Inventory.inventory[i] = item
			break
	itemlist.inventoryupdate()
	#player.get_node("Sprite").texture = load(item["itemsprite"])
