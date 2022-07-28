#kevin du 2022 heheha
extends Actor
class_name player, "res://Resources/Textures/Kinematic/Player1.tres"

export var maxhealth = 100

var lookcd: float = 1
var dust: float = 0
var slide: bool = false
var combattimer = 0
var stamina = 100

onready var health = maxhealth
onready var sprite = $Sprite
onready var animationTree = $AnimationTree
onready var animationPlayer = $AnimationTree/AnimationPlayer
onready var tween = $Tween
onready var MI = get_node("/root/Node2D/GUI/UI/MouseIndicator/KillMe")
onready var raycast: RayCast2D = $RayCast2D

#main player movement script
func _physics_process(delta):
	if Globals.god:
		health = maxhealth
	randomize()
	update()
	velocity = movevelocity + kinematicvelocity
	lookcd = max(lookcd - delta, 0)
	dust = max(dust - delta, 0)

	combattimer = max(combattimer - delta, 0)
	if combattimer == 0:
		stamina = min(100, stamina + 5 * delta)
		health = min(maxhealth, health + 10 * delta)
	
	Globals.playerhealth = health	
	Globals.playerstamina = stamina

	raycast.cast_to = (get_local_mouse_position() + Vector2(0,30)).clamped(250)

	#used to get the direction player wants to move
	var direction: = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	direction = direction.normalized()
	if Input.is_action_just_pressed("warp") and stamina > 20:
		stamina -= 20
		if raycast.is_colliding():
			global_position = raycast.get_collision_point()
		else:
			global_position = to_global(raycast.cast_to)
		$Particles2D.emitting = true


	#if clicking disregard normal sprite flipping rules and change sprite to look at player
	#moved to weaponconteroller

	if Input.is_action_pressed("left_click") and MI.visible:
		#if get_local_mouse_position().x > 0:
			#sprite.flip_h = false
			#animationTree.set("parameters/AttackAnim/blend_position", -1)
		#elif get_local_mouse_position().x < 0:
			#sprite.flip_h = true
			#animationTree.set("parameters/AttackAnim/blend_position", 1)
		lookcd = 1
		#animationTree.set("parameters/Attack/active", true)
	
	#otherwise flip sprite in direction of movement
	elif animationTree.get("parameters/Attack/active") == false and lookcd == 0 and direction != Vector2.ZERO:
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true
	
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_up"):
		animationTree.set("parameters/Walk/add_amount", 1)
	else:
		#yield(self, "walkend")
		animationTree.set("parameters/Walk/add_amount", 0)

	#play animation
	if direction != Vector2.ZERO:
		movevelocity += acceleration * direction
		if Input.is_action_pressed("sprint") and stamina > 0:
			movevelocity = movevelocity.clamped(maxspeed * 1.2)
			stamina = stamina - 25 * delta 
		else:
				movevelocity = movevelocity.clamped(maxspeed)
		#make dust particles when walking
		if dust == 0:
			dust = (0.5 + randf())/5
			var p: Particles2D = load("res://Resources/Shaders/Particles/DustParticle.tscn").instance()
			p.position = self.global_position
			p.one_shot = true

			var img = get_viewport().get_texture().get_data()
			img.flip_y()
			img.lock()
			p.modulate = img.get_pixel(int(get_viewport_rect().size.x/2),int(get_viewport_rect().size.y/2))

			get_tree().get_root().add_child(p)
			p.emitting = true
			yield(get_tree().create_timer((p.lifetime * 2)/p.speed_scale), "timeout")
			p.queue_free()
	elif !slide:
		movevelocity = movevelocity.normalized() * stepify(movevelocity.length() * 0.8, 0.0001)
		if movevelocity.length() <= 0.01:
			movevelocity = Vector2.ZERO
	if !slide:
		kinematicvelocity = kinematicvelocity.normalized() *  stepify(kinematicvelocity.length() * 0.9, 0.0001)
		if kinematicvelocity.length() <= 0.01:
			kinematicvelocity = Vector2.ZERO
	else:
		kinematicvelocity = kinematicvelocity.normalized() *  stepify(kinematicvelocity.length() * 0.95, 0.0001)

func damage(damage, kbvector, kbslide):
	combattimer = 10
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
		get_node("/root/Node2D/GUI/UI").transitioning = true
		sprite.modulate = Color.red

func _draw():
	if raycast.is_colliding():
		draw_circle(to_local(raycast.get_collision_point()) + Vector2(0,-30),3,Color.aqua)
	else:
		draw_circle(raycast.cast_to + Vector2(0,-30),3,Color.aqua)

func _on_AnimationPlayer_animation_finished(_anim_name):
	pass