#kevin du 2022 2022 2022 2022 2022 2022 2022 
extends Node2D
class_name Item

onready var player = get_node("/root/Node2D/YSort/Player")
onready var inventory = get_node("/root/Node2D/YSort/Player/Inventory")
onready var label = $Label
onready var sprite = $Sprite
onready var tween = $Tween

var iteminfo = {}
var opacity1 = 0
var opacity2 = 0
var pickup = 0
var mouseover = false
var pickupenabled = false


#abstract class extended by all actual pickupable items to pick up and delete said item
func _process(_delta):
	#change how item looks depending on if character is near it
	$Label.modulate.a = opacity2
	#if nearby or moused over highlight object
	if (pickupenabled or mouseover) and pickup == 0:
		if pickupenabled:
			opacity1 = min(opacity1 + 0.02, 1)
			opacity2 = min(opacity2 + 0.02, 1.5)
			$Sprite.material.set_shader_param("color", Color(255, 255, 0, float(opacity1)/255))
		else:
			opacity1 = min(opacity1 + 0.02, 0.5)
			$Sprite.material.set_shader_param("color", Color(255, 255, 255, float(opacity1)/255))
	#else dont
	if !pickupenabled and pickup == 0:
		if !pickupenabled and !mouseover:
			opacity1 = max(opacity1 - 0.03, 0)
			opacity2 = max(opacity2 - 0.03, 0)
			$Sprite.material.set_shader_param("color", Color(255, 255, 255, float(opacity1)/255))
		else:
			opacity1 = max(opacity1 - 0.03, 0.5)
			opacity2 = max(opacity2 - 0.03, 0)
			$Sprite.material.set_shader_param("color", Color(255, 255, 255, float(opacity1)/255))
	
	#how to handle pickup
	if pickup != 0:
		pickup += 1
		self.scale = Vector2(1 - pickup/20,1 - pickup/20)
		self.modulate.a = (1 - pickup/50)
		if pickup > 50:
			queue_free()
		if self.scale.x <= 0:
			self.rotation_degrees = 180

#if in area and press G pick up
func _input(event):
	if pickupenabled and event is InputEventKey and event.scancode == KEY_G and event.is_pressed() and pickup == 0:
		$ItemCollision.disabled = true
		tween.interpolate_property(self, "position", null, player.global_position, 0.3, tween.TRANS_BACK, tween.EASE_OUT)
		tween.start()
		pickup = float(1)
		opacity2 = 0
		if name == "Key":
			Globals.keygot = true
		inventory.GetItem(Globals.itemdata[name])

#link functions
func _on_Area2D_body_entered(body):
	if body == player:
		pickupenabled = true

func _on_Area2D_body_exited(body):
	if body == player:
		pickupenabled = false
		
func _on_Area2D_mouse_entered():
	mouseover = true

func _on_Area2D_mouse_exited():
	mouseover = false
