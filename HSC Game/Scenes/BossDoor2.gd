extends StaticBody2D

func _process(_delta):
    if Globals.finalbossstart:
        scale = Vector2(1.333,1.333)
        position = Vector2(-320,-1152)
    else:
        position = Vector2(0,-1152)
        scale = Vector2.ZERO