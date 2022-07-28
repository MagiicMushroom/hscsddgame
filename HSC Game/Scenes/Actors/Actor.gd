#kevin du 2022 i am getting a new laptop soon thats pretty cool!
extends KinematicBody2D
class_name Actor, "res://Resources/Textures/Kinematic/TrainingDummy.tres"

export var maxspeed = 100
export var acceleration = 100
export var mass = 1.0

var velocity: = Vector2.ZERO
var kinematicvelocity: = Vector2.ZERO
var movevelocity: = Vector2.ZERO

#actually moves the kinematicbody2d, all things with movement extend this class and thus have this function
func _physics_process(_delta) -> void:
	if move_and_slide(velocity):
		pass
