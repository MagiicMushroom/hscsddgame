#scrapped idea
extends ItemList

func _process(_delta):
	for item in Inventory.inventory:
		if item["sorted"] == false:
			item["sorted"] = true
			add_item(item["itemname"], load(item["itemsprite"]))
