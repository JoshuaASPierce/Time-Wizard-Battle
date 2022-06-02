extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var instructionScene
export(PackedScene) var creditScene
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_pressed():
	get_tree().change_scene("res://Main.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Instructions_pressed():
	var instru = instructionScene.instance()
	self.add_child(instru)
	


func _on_Credits_pressed():
	var credits = creditScene.instance()
	self.add_child(credits)
