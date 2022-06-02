extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 50
export var velocity = Vector2.ZERO
export var pointValue = 100
export var gravity = 100
var forward = true
var turn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = 'default'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if forward:
		velocity.x = speed
		$Area2D/CollisionShape2D.position.x = 13
		$RayCast2D.position.x = 16
		$AnimatedSprite.flip_h = false
	else: 
		velocity.x = -speed
		$Area2D/CollisionShape2D.position.x = -13
		$RayCast2D.position.x = -16
		$AnimatedSprite.flip_h = true
	velocity.y = gravity
	move_and_slide(velocity, Vector2.UP)
	if turn and !$RayCast2D.is_colliding():
		forward = !forward
		turn = false
		$turn.start()


func _on_Area2D_body_entered(body):
	if body.is_in_group('character'):
		body.death(false)
	else:
		forward = !forward

func _on_HitBox_body_entered(body):
	if body.is_in_group('character'):
		body.get_node("HUD").score(pointValue)
		$AnimatedSprite.animation = 'death'
		$Area2D/CollisionShape2D.disabled = true
		$death.play()
		$freeTimer.start()


func _on_freeTimer_timeout():
	queue_free()


func _on_turn_timeout():
	turn = true
