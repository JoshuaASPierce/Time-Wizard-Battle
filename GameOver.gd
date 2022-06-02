extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Score.text = "Score: " + str(get_parent().score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()




func _on_Quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")
