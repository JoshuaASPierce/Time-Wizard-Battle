extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 75
export var velocity = Vector2.ZERO
export var pointValue = 50
var forward = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = 'default'


func _process(delta):
	if forward:
		velocity.x = speed
		$AnimatedSprite.flip_h = false
	else: 
		velocity.x = -speed
		$AnimatedSprite.flip_h = true
	move_and_slide(velocity, Vector2.UP)


func _on_hit_body_entered(body):
	if body.is_in_group('character'):
		body.death(false)
	else:
		forward = !forward
		$TurnTimer.stop()
		$TurnTimer.start()

func _on_kill_body_entered(body):
	if body.is_in_group('character'):
		body.get_node("HUD").score(pointValue)
		$AnimatedSprite.animation = 'death'
		$hit/CollisionShape2D.disabled = true
		$death.play()
		$DeathTimer.start()


func _on_TurnTimer_timeout():
	forward = !forward


func _on_DeathTimer_timeout():
	queue_free()
