#kevin du 2022 please kill me oh god
extends Node2D

var radsto

#placeholder script, was just testing how to call functions from other scripts

func MouseMove():
	#when mouse moves, change mouse indicator rotation and position
	$Node2D.position = get_local_mouse_position()
	radsto = Vector2(0,-20).angle_to_point($Node2D.position) - 3*PI/4
	$Node2D.set_rotation(radsto)
