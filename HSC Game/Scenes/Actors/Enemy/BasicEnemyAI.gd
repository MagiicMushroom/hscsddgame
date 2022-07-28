	#kevin du 2022 on the sdd grind wohoo!
extends Enemy
class_name BasicEnemy

#define variables
export var attackdelay = 3.0
export var attackdamage = 10
export var maxhealth = 100
export var knockback = 1.0
export var knockbackslide = false
export var attackwindup = 0.5
export var minchaserange = 20
export var patrolrefreshtime = 10

var random = RandomNumberGenerator.new()
var chase: bool = false
var attacking: bool = false
var patrolling: bool = false
var radsto
var direction
var slide = false
var canseeplayer: bool = false

onready var attackcooldown = 0
onready var health = maxhealth
onready var patrolcooldown = patrolrefreshtime
onready var tween = $Tween
onready var line = $Line2D
onready var animationPlayer = $AnimationTree/AnimationPlayer
onready var ray = $LineOfSight

#the movement stuff
func _physics_process(delta):
	update()
	velocity = movevelocity + kinematicvelocity

	direction = $Center.global_position.direction_to(player.get_node("Center").global_position)
	radsto = $Center.global_position.angle_to_point(player.get_node("Center").global_position) 
	attackcooldown = max(attackcooldown - delta, 0)

	#check if it can see the player
	ray.cast_to = to_local(player.global_position) + Vector2(0,10)
	if ray.get_collider() == player.get_node("RaycastIntercept"):
		canseeplayer = true
	else:
		canseeplayer = false
	
	#black magic aka yield, when an attack is declared a 0.5 second timer is started, which then calls the attack func once done. 
	if attacking and attackcooldown == 0:
		if rad2deg(radsto) >= 90 and rad2deg(radsto) <= 270:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
		attackcooldown = attackdelay
		yield(get_tree().create_timer(attackwindup), "timeout")
		attack()
	
	#printerr("chase:",chase," attack:",attacking," flip:", sprite.flip_h)

	if chase:
		if movevelocity.x < 0:
			sprite.flip_h = false
		elif movevelocity.x > 0:
			sprite.flip_h = true
		else:
			if rad2deg(radsto) >= -90 and rad2deg(radsto) <= 90:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
	if !attacking and chase and canseeplayer and $Center.global_position.distance_to(player.get_node("Center").global_position) >= minchaserange:
		patrolling = false
		#play walk animation
		animationTree.set("parameters/Walk/add_amount", 1)

		#make the enemy behave realistically using acceleration
		get_node("PlayerCheck").set_rotation(radsto)
		movevelocity += acceleration * direction
		movevelocity = movevelocity.clamped(maxspeed)
	else:
		#make animations stop
		animationTree.set("parameters/Walk/add_amount", 0)

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
	
	if !chase and velocity == Vector2.ZERO and !patrolling:
		sprite.flip_h = false
		patrolling = true
	
	#patrolling check
	if patrolling:
		if patrolcooldown <= 0:
			patrol()	
			patrolcooldown = patrolrefreshtime - random.randf_range(0,float(patrolrefreshtime)/3)
		else:
			patrolcooldown = patrolcooldown - delta

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

func patrol():
	random.randomize()
	radsto = random.randi_range(1,360)
	movevelocity = Vector2.UP.rotated(deg2rad(radsto)) * acceleration
	get_node("PlayerCheck").set_rotation_degrees(radsto)
	if radsto >= 90 and radsto <= 270:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

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
		queue_free()


#when player enteres or exits aggro radius, toggle chase
func _on_PlayerCheck_body_entered(body):
	if body == player:
		chase = true

func _on_PlayerCheck_body_exited(body):
	if body == player:
		chase = false

#draw the chase line
func _draw():
	if !Globals.drawline:
		line.points[0] = Vector2.ZERO
	elif chase and canseeplayer:
		line.points[0] = to_local(player.global_position) + Vector2(0,10)
	else:
		line.points[0] = Vector2.ZERO

func _on_AttackAble_entered(body):
	if body == player:
		attacking = true


func _on_AttackAble_exited(body):
	if body == player:
		attacking = false
