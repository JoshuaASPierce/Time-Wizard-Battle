extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var velocity = Vector2(100, 100)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity, Vector2.UP)

func death(arg):
	position = get_parent().get_node("Spawn").position


func _on_Area2D_body_entered(body):
	if body.is_in_group('character'):
		body.death(false)
