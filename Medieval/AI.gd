extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var badguy
export var forwardMove = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VisibilityNotifier2D_screen_entered():
	var mob = badguy.instance()
	add_child(mob)
	mob.position = $Spawn.position
	mob.forward = forwardMove
