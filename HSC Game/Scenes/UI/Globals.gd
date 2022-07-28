#kevin du 2022
extends Node2D
class_name Keycodes

#global variables!!!
var keycodes = {
   KEY_0:0,
   KEY_1:1,
   KEY_2:2,
   KEY_3:3,
   KEY_4:4,
   KEY_5:5,
   KEY_6:6,
   KEY_7:7,
   KEY_8:8,
   KEY_9:9,
}

var drawline
var god
var finalbossstart
var keygot
var win
var playerhealth
var playerstamina
var maxinvsize = 30
var selectedweapon = null
var offhandweapon = null

var itemdata = {
   "WoodenSword": { 
      "item": "WoodenSword",
      "itemname": "Wooden Sword",
      "itemcategory": "weapon",
      "itemattack": 5,
      "itemattacktype": "swing",
      "itemdamagetype": "blunt",
      "itemspeed": 0,
      "itemattackspeed": 0.75,
      "itemmaxuses": 50,
      "itemdescription": "A wooden training sword, very crusty but still servicable as a weapon (if you count a baseball bat as a weapon, that is).",
		"itemcode": 0,
		"itemsprite": "res://Resources/Textures/Item/WoodenSword.tres",
      "itemscene": "res://Scenes/Items/Pickups/WoodenSwordPickup.tscn",
      "weaponscene": "res://Scenes/Items/Equippables/WoodenSword.tscn"
   },
   "IronSword": {
      "item": "IronSword",
		"itemname": "Iron Sword",
      "itemcategory": "weapon",
      "itemattack": 30,
      "itemattacktype": "swing",
      "itemdamagetype": "sharp",
      "itemspeed": -10,
      "itemattackspeed": 1.2,
      "itemmaxuses": 200,
      "itemdescription": "Somewhat sturdy and very cheap, the iron sword is the go to weapon for bandits, goblins and adventurers. Quite heavy.",
		"itemcode": 1,
		"itemsprite": "res://Resources/Textures/Item/IronSword.tres",
      "itemscene": "res://Scenes/Items/Pickups/IronSwordPickup.tscn",
      "weaponscene": "res://Scenes/Items/Equippables/IronSword.tscn"
	},
   "Fist": {
      "item": "Fist",
		"itemname": "Fists",
      "itemcategory": "weapon",
      "itemattack": 5,
      "itemattacktype": "stab",
      "itemdamagetype": "blunt",
      "itemspeed": 20,
      "itemattackspeed": 0.4,
      "itemmaxuses": -1,
      "itemdescription": "Wait...This is a dev item...",
		"itemcode": 2,
		"itemsprite": "res://Resources/Textures/Item/fisting.png",
      "itemscene": "res://Scenes/Items/Pickups/FistPickUp.tscn",
      "weaponscene": "res://Scenes/Items/Equippables/Fists.tscn"
	},
   "Key": {
      "item": "Key",
		"itemname": "Fists",
      "itemcategory": "key",
      "itemmaxuses": -1,
      "itemdescription": "Key",
		"itemcode": 3,
		"itemsprite": "res://Resources/Textures/Kinematic/key.png",
      "itemscene": "res://Scenes/Items/Pickups/KeyPickUp.tscn",
      "weaponscene": ""
	}
}