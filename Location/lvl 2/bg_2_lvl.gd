extends ParallaxBackground

var speed = 25

func _process(delta):
	scroll_offset.x -= speed * delta

