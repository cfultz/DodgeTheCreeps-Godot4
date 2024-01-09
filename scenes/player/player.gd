extends Area2D

@export var speed = 400
var screen_size
signal hit



func _ready():
	screen_size = get_viewport_rect().size
	hide()
	
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$PlayerAnimation.play()
	else:
		$PlayerAnimation.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$PlayerAnimation.animation = "walk"
		$PlayerAnimation.flip_v = false
	# See the note below about boolean assignment.
		$PlayerAnimation.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$PlayerAnimation.animation = "up"
		$PlayerAnimation.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide()
	hit.emit()
	$Collision.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$Collision.disabled = false
