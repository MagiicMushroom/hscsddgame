#kevin du 2022 nearly there!
#used to make parallex effect in the title screen
extends ParallaxBackground

export var layer2: float = 0
export var layer3: float = 0
export var layer4: float = 0
export var layer5: float = 0

func _process(delta):
	self.scale.x = OS.window_size.x / 1024
	self.scale.y = OS.window_size.y / 600
	$PL2.motion_offset.x += layer2 * delta
	$PL3.motion_offset.x += layer3 * delta
	$PL4.motion_offset.x += layer4 * delta
	$PL5.motion_offset.x += layer5 * delta
