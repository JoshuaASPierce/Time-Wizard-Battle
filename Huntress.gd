extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2.ZERO
export var speedBase = 200
var speed = 200
export var gravity = 2000
var attack = false
var forward = true

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = speedBase


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = speed
	velocity.y = gravity
	move_and_slide(velocity, Vector2.UP)


func _on_Hitbox_body_entered(body):
	if attack and body.is_in_group('character'):
		body.death(false)


func _on_Run_timeout():
	attack = true
	speed = 0
	$AnimatedSprite.animation = 'Attack'
	$Attack.start()
	

func _on_Attack_timeout():
	attack = false
	if forward:
		forward = false
		speed = speedBase
		$AnimatedSprite.flip_h = false
	else:
		forward = true
		speed = -speedBase
		$AnimatedSprite.flip_h = true
	$AnimatedSprite.animation = 'Run'
	$Run.start()


func _on_Hit_body_entered(body):
	if body.is_in_group('character'):
		body.death(false)
