extends Node2D

#These arrays of packed scenes represent the different time periods
export(Array, PackedScene) var testScenes
export(Array, PackedScene) var testScene2
export(Array, PackedScene) var stoneAgeScenes
export(Array, PackedScene) var bronzeAgeScenes
export(Array, PackedScene) var medievalAgeScenes
export(Array, PackedScene) var renaissanceAgeScenes
export(Array, PackedScene) var industrialAgeScenes
export(Array, PackedScene) var theGreatWarAgeScenes
export(Array, PackedScene) var modernAgeScenes
export(Array, PackedScene) var digitalAgeScenes
export(Array, PackedScene) var futureAgeScenes
#the current location to place the next scene
var currentLoc = 0
#The previously used index for scenes
var prevIndex = 0

var prevScene
#RandomNumberGenerator for use later
var rng = RandomNumberGenerator.new()
#The current totaled height of pieces placed
export var currentHeight = 0
#the current totaled distance traveled by pieces placed
export var currentWidth = 0
#The current set of scenes being used is stored here
var currentScenes

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	prevScene = testScenes[0].instance()
	currentScenes = stoneAgeScenes
	#Add starting scenes
	addNext(currentScenes)
	$Stone.volume_db = 0
	$Industrial.volume_db = -80
	$Medieval.volume_db = -80
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func addNext(curSceneList):
	#Grab a random index from the current scene list
	var index = rng.randi_range(0, curSceneList.size()-1)
	#Make sure the index does not match the previous index used
	while index == prevIndex:
		index = rng.randi_range(0, curSceneList.size()-1)
	#add the final height of the previous piece to the height to generate at
	currentHeight += int(prevScene.get_node("Height").position.y)
	#Make a new platform scene per the current scene list and chosen index
	var platform = curSceneList[index].instance()
	#Add the platform to the main scene
	self.add_child(platform)
	
	#Connect the deleted signal from the platform.gd script to the appropriate function
	platform.connect("deleted", self, "_on_platform_delete")
	#Place the platform at the current width and height given
	platform.global_position.x = currentWidth
	platform.global_position.y = currentHeight
	#Add the platform's width to the current distance we've got
	currentWidth += int(platform.get_node("Height").position.x)
	#Make the prevIndex equal to the index (As it is now the previous index)
	prevIndex = index
	#Make the platform the previous scene
	prevScene = platform
	

func deleteLast():
	pass

func _on_platform_delete(platform):
	addNext(currentScenes)

#Changes the scene list to the next in the line
func nextScenes():
	if currentScenes == stoneAgeScenes:
		$AnimationPlayer.play("medievalTrans")
		currentScenes = medievalAgeScenes
	elif currentScenes == medievalAgeScenes:
		$AnimationPlayer.play("industrialTrans")
		currentScenes = industrialAgeScenes
	elif currentScenes == industrialAgeScenes:
		$AnimationPlayer.play("stoneTrans")
		currentScenes = stoneAgeScenes
		



func _on_Timer_timeout():
	nextScenes()
