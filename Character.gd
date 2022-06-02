extends KinematicBody2D

#The velocity variable
export var velocity = Vector2.ZERO
#The max speed reached by character
export var maxSpeed = 1000
#The accelleration variable (Not gravitys acceleration)
export var accel = .25
#The jump speed. Make sure its negative. 
export var jumpSpeed = -750
#The acceleration due to gravity
export var gravity = 2000

export var minSpeed = 250

export var friction = .01

var crouch = false

var hittable = true

var boost = false

export var boostSpeed = 500

export(PackedScene) var pauseScene
export(PackedScene) var gameOverScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = 'Run'
	$CollisionShape2D.rotation_degrees = 0
	crouch = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#If you press down, and you arent crouching, crouch. 
	if Input.is_action_just_pressed("ui_down") and !crouch:
		crouch = true
		$Crouch.start()
		$CollisionShape2D.rotation_degrees = 90
		$Crouch2.play()
	if Input.is_action_just_pressed("ui_cancel"):
		pause()
	#If crouching, slow down
	if crouch:
		velocity.x = lerp(velocity.x, minSpeed, friction)
	#Otherwise, speed up to maxspeed
	elif boost:
		velocity.x = lerp(velocity.x, boostSpeed, 1)
	else:
		#Linear interpolation to accelerate the speed smoothly.
		velocity.x = lerp(velocity.x, maxSpeed, accel)
	#Checks if the character is colliding on the floor. 
	if !hittable:
		$AnimatedSprite.animation = 'Hit'
	elif is_on_floor() and !crouch:
		#Sets the animation to run
		$AnimatedSprite.animation = 'Run'
	elif crouch:
		#Sets the animation to crouch
		$AnimatedSprite.animation = 'Crouch'
	else:
		#otherwise, we are jumping
		#Replace with more sophisticated stuff if we have seperate falling animations
		$AnimatedSprite.animation = 'Jump'
	#When the "Accept" key is pressed (Space bar),
	#And the character is on the floor
	if Input.is_action_just_pressed("ui_up") and (is_on_floor()):
		#Set the y velocity to the jump speed
		velocity.y = jumpSpeed
		#Run the jump function
		jump()
	#add the gravity velocity to the y velocity
	velocity.y += gravity * delta
	#Move and slide per the up vector and the velocity given.
	velocity = move_and_slide(velocity, Vector2.UP)
	

func pause():
	var pause = pauseScene.instance()
	self.add_child(pause)
	
	get_tree().paused = !get_tree().paused

#Called when a jump is made
func jump():
	$Jump.play()

func death(pitBool):
	if pitBool:
		dead()
	elif hittable:
		$HUD.shield -= $HUD.hitAmount
		hittable = false
		$HUD.multiplier = $HUD.defaultMultiplier
		$HitTimer.start()
		$Hit.play()
	if $HUD.shield <= 0:
		dead()

func dead():
	var gameOver = gameOverScene.instance()
	$HUD.add_child(gameOver)
	
	get_tree().paused = !get_tree().paused

func boost():
	boost = true
	$Boost.play()
	$BoostTimer.start()

func _on_Crouch_timeout():
	crouch = false
	$CollisionShape2D.rotation_degrees = 0


func _on_HitTimer_timeout():
	hittable = true

func _on_HUD_enemyAttack():
	death(false)


func _on_BoostTimer_timeout():
	boost = false
