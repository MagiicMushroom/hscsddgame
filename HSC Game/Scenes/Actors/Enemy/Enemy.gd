#kevin du 2022 oh the misery
extends Actor
#everybody wants to be my
class_name Enemy

#more dictionary classes yay, this one defines what the player is, what the sprite is, and what the animation player is.
onready var player = get_node("/root/Node2D/YSort/Player")
onready var sprite = $Sprite
onready var animationTree = $AnimationTree