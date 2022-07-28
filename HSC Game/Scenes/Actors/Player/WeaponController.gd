#kevin du 2022 the top row of my keyboad is qwertyuiop!
extends Node2D

var selectedweapon
var selectedweaponscene: Node2D
var offhandweapon
var offhandweaponscene: Node2D
var previouskey
var attackcooldown = 0
var angleto
var hitthisswing = []

onready var player = find_parent("Player")
onready var animationTree = player.get_node("AnimationTree")
onready var animationPlayer = $AnimationPlayer
onready var sprite = player.get_node("Sprite")

#this function is a failure, like half my project. will fix during holidays, for now i just duct taped it together into something resembling a function.
func _process(delta):
	attackcooldown = max(attackcooldown - delta,0)
	angleto = self.global_position.angle_to_point(get_global_mouse_position())
	if abs(rad2deg(angleto)) < 90:
		$Fists.scale.y = -1
		$IronSword.scale.y = -1
		$WoodenSword.scale.y = -1
	else:
		$Fists.scale.y = 1
		$IronSword.scale.y = 1
		$WoodenSword.scale.y = 1
	$Fists.rotation_degrees = rad2deg(angleto) - 180
	$IronSword.rotation_degrees = rad2deg(angleto) - 180
	$WoodenSword.rotation_degrees = rad2deg(angleto) - 180

	"""
	if Globals.selectedweapon == null:
		selectedweapon = "Fist"
	if Globals.offhandweapon == null:
		offhandweapon = "Fist"
	"""
	if Input.is_action_pressed("left_click"):
		if get_local_mouse_position().x > 0:
			sprite.flip_h = false
			animationTree.set("parameters/AttackAnim/blend_position", -1)
		elif get_local_mouse_position().x < 0:
			sprite.flip_h = true
			animationTree.set("parameters/AttackAnim/blend_position", 1)
		if attackcooldown == 0:
			hitthisswing = []
			animationPlayer.play("RESET")
			animationPlayer.play("WeaponAttack")
			animationTree.set("parameters/Attack/active", true)
			if $Fists.visible:
				for body in $Fists/Area2D.get_overlapping_bodies():
					if body != player and body.has_method("damage"):
						body.damage(10,get_local_mouse_position().normalized(),false)
				attackcooldown = 0.4
			if $WoodenSword.visible:
				yield(get_tree().create_timer(0.3), "timeout")
				for body in $WoodenSword/Area2D.get_overlapping_bodies():
					if body != player and body.has_method("damage") and !hitthisswing.has(body):
						hitthisswing.append(body)
						body.damage(25,get_local_mouse_position().normalized()*2,false)
				attackcooldown = 0.75
			if $IronSword.visible:
				yield(get_tree().create_timer(0.5), "timeout")
				for body in $IronSword/Area2D.get_overlapping_bodies():
					if body != player and body.has_method("damage") and !hitthisswing.has(body):
						hitthisswing.append(body)
						body.damage(50,get_local_mouse_position().normalized()*3,true)
				attackcooldown = 1.5


func _ready():
	if Globals.selectedweapon == null:
		selectedweapon = "Fist"
	if Globals.offhandweapon == null:
		offhandweapon = "Fist"
	switchweapons()

func switchweapons():
	"""
	if selectedweapon != Globals.selectedweapon and Globals.selectedweapon != null:
		remove_child(selectedweaponscene)
		selectedweaponscene = load(Globals.itemdata[Globals.selectedweapon]["weaponscene"]).instance()
		add_child(selectedweaponscene)
		selectedweapon = Globals.selectedweapon
	elif selectedweapon == "Fist":
		remove_child(selectedweaponscene)
		selectedweaponscene = load("res://Scenes/Items/Equippables/Fists.tscn").instance()
		add_child(selectedweaponscene)
	if offhandweapon != Globals.offhandweapon and Globals.offhandweapon != null:
		remove_child(offhandweaponscene)
		offhandweaponscene = load(Globals.itemdata[Globals.offhandweapon]["weaponscene"]).instance()
		add_child(offhandweaponscene)
		offhandweapon = Globals.offhandweapon
	elif offhandweapon == "Fist":
		remove_child(offhandweaponscene)
		offhandweaponscene = load("res://Scenes/Items/Equippables/Fists.tscn").instance()
		add_child(offhandweaponscene)
		"""
	pass
	
		
#switching weapons
func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.scancode in Globals.keycodes:
			if Globals.keycodes[event.scancode] == previouskey:
					player.maxspeed = 120
					$Fists.visible = false
					$WoodenSword.visible = false
					$IronSword.visible = false
			previouskey = Globals.keycodes[event.scancode]
			match Globals.keycodes[event.scancode]:
				1:
					player.maxspeed = 120
					$Fists.visible = true
					$WoodenSword.visible = false
					$IronSword.visible = false
				2:
					player.maxspeed = 100
					$Fists.visible = false
					$WoodenSword.visible = true
					$IronSword.visible = false
				3:
					player.maxspeed = 70
					$Fists.visible = false
					$WoodenSword.visible = false
					$IronSword.visible = true
