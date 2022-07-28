#kevin du 2022 on the sdd grind wohoo!
extends Enemy

#define variables
export var attackdelay = 3.0
export var attackdamage = 10
export var maxhealth = 100
export var knockback = 1.0
export var knockbackslide = false
export var attackwindup = 0.5
export var minchaserange = 20

var random = RandomNumberGenerator.new()
var chase
var attacking: bool = false
var radsto
var direction
var slide = false

onready var attackcooldown = 0
onready var health = maxhealth
onready var hammer = get_node("PlayerCheck/Hammer")
onready var tween = $Tween
onready var line = $Line2D
onready var animationPlayer = $AnimationTree/AnimationPlayer

#the movement stuff
func _physics_process(delta):
	update()
	velocity = movevelocity + kinematicvelocity

	direction = $Center.global_position.direction_to(player.get_node("Center").global_position)
	radsto = $Center.global_position.angle_to_point(player.get_node("Center").global_position) 
	attackcooldown = max(attackcooldown - delta, 0)

	if rad2deg(radsto) >= -90 and rad2deg(radsto) <= 90:
		hammer.scale.y = -1
	else:
		hammer.scale.y = 1

	#black magic aka yield, when an attack is declared a 0.5 second timer is started, which then calls the attack func once done. 
	if attacking and attackcooldown == 0:
		if rad2deg(radsto) >= 90 and rad2deg(radsto) <= 270:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
		attackcooldown = attackdelay
		yield(get_tree().create_timer(attackwindup), "timeout")
		attack()
	
	#printerr("chase:",chase," attack:",attacking," flip:", sprite.flip_h)

	if chase:
		if movevelocity.x < 0:
			sprite.flip_h = true
		elif movevelocity.x > 0:
			sprite.flip_h = false
		else:
			if rad2deg(radsto) >= -90 and rad2deg(radsto) <= 90:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
	if chase and $Center.global_position.distance_to(player.get_node("Center").global_position) >= minchaserange:
		$Sprite.texture = load("res://Resources/Textures/Kinematic/Orcs/FinalBoss/FinalBossRun.tres")
		#make the enemy behave realistically using acceleration
		get_node("PlayerCheck").set_rotation(radsto - PI)
		movevelocity += acceleration * direction
		movevelocity = movevelocity.clamped(maxspeed)
	else:
		$Sprite.texture = load("res://Resources/Textures/Kinematic/Orcs/FinalBoss/FinalBossIdle.tres")
		#make animations 
		pass
		#make the enemy slow down and when speed is near zero set to zero
	if !slide:
		movevelocity = movevelocity.normalized() * stepify(movevelocity.length() * 0.8, 0.0001)
		if movevelocity.length() <= 0.01:
			movevelocity = Vector2.ZERO
		kinematicvelocity = kinematicvelocity.normalized() *  stepify(kinematicvelocity.length() * 0.9, 0.0001)
		if kinematicvelocity.length() <= 0.01:
			kinematicvelocity = Vector2.ZERO
	else:
		kinematicvelocity = kinematicvelocity.normalized() *  stepify(kinematicvelocity.length() * 0.95, 0.0001)
		movevelocity = movevelocity.normalized() * stepify(velocity.length() * 0.8, 0.0001)
		if movevelocity.length() <= 0.01:
			movevelocity = Vector2.ZERO
	
func attack():
	if rad2deg(radsto) >= -90 and rad2deg(radsto) <= 90:
		sprite.flip_h = true
		animationTree.set("parameters/AttackAnim/blend_position", 1)
	else:
		sprite.flip_h = false
		animationTree.set("parameters/AttackAnim/blend_position", -1)
	animationTree.set("parameters/Attack/active", true)
	if attacking:
		var kbvector = knockback * direction.normalized()
		player.damage(attackdamage, kbvector, knockbackslide)
func damage(damage, kbvector, kbslide):
	if damage > 0:
		tween.interpolate_property(sprite, "modulate", Color.red, Color.white, 0.3)
		tween.start()
	kinematicvelocity += 150 * kbvector / mass
	health -= damage
	if health <= 0:
		die()
	if kbslide:
		slide = true
		yield(get_tree().create_timer(0.3), "timeout")
		slide = false
	
func die():
	if false:
		pass
	else:
		animationPlayer.play("Die")
		tween.interpolate_property(self, "modulate", Color.red, Color.transparent, 0.5)
		tween.start()
		yield(tween,"tween_all_completed")
		get_node("/root/Node2D/GUI/UI").transitioning = true
		Globals.win = true
		queue_free()


#when player enteres or exits aggro radius, toggle chase
func _on_PlayerCheck_body_entered(body):
	if body == player:
		Globals.finalbossstart = true
		chase = true

#draw the chase line
func _draw():
	if !Globals.drawline:
		line.points[0] = Vector2.ZERO
	elif chase:
		line.points[0] = to_local(player.global_position) + Vector2(0,10)
	else:
		line.points[0] = Vector2.ZERO

func _on_AttackAble_entered(body):
	if body == player:
		attacking = true

func _on_AttackAble_exited(body):
	if body == player:
		attacking = false
