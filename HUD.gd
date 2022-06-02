extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var yearsPerSecond = 20
var currentYear = -60
export var maxYears = 3000
export var alpha = .5
export var alphaMax = .75
export var alphaMin = .2
var alphaUp = true
export var counter = .7
var attackActive = true

export var hitAmount = 15

export var shield = 50

export var attack = 0

export var attackMax = 100

export var shieldMax = 100

export var attackIncrement = 12

export var shieldIncrement = 2

export var score = 0

export var defaultScore = 0

export var defaultMultiplier = 1.0

export var maxMultiplier = 4.9

signal enemyAttack

export var dialog = false
#When true, a dialog will popup reminding players to try to 
#charge their shield
var tutCharge = false

var tutAttack = true

#The enemywizard is on screen
var enemyWizard = false
#the enemy is targetable
var enemyTargetable = false
#The amount of points an enemy gives when hit succesfully
export var enemyScore = 1000
#the points gained every second
export var pointsPerSecond = 10
#points multiplier
var multiplier = 1.0

var witchVisits = 0

export var multiplierIncrement = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	score = defaultScore
	multiplier = defaultMultiplier


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if enemyTargetable and tutAttack:
		$tutAttackLabel.visible = true
	else:
		$tutAttackLabel.visible = false
	$tutShieldLabel.visible = tutCharge
	currentYear += yearsPerSecond * delta
	$year.text = "Current Year: " + str(int(currentYear))
	if currentYear > maxYears:
		currentYear = 0
	if Input.is_action_just_pressed("ui_right"):
		attackActive = !attackActive
		tutCharge = false
		$tutShieldTimer.stop()
	if Input.is_action_just_pressed("ui_left") and enemyTargetable and attack >= attackMax:
		score(enemyScore)
		attack = 0
		hitWizard()
		tutAttack = false
	elif Input.is_action_just_pressed("ui_left") and !enemyTargetable and attack >= attackMax:
		miss()
	if attackActive and attack < attackMax:
		attack += attackIncrement * delta
		if $attackCharge.playing == false:
			$attackCharge.play()
		$shieldCharge.stop()
		if attack >= attackMax:
			$charged.play()
	elif !attackActive and shield < shieldMax:
		shield += shieldIncrement * delta
		if $shieldCharge.playing == false:
			$shieldCharge.play()
		$attackCharge.stop()
	else:
		$attackCharge.stop()
		$shieldCharge.stop()
	if alphaUp:
		alpha += counter * delta
	else:
		alpha -= counter * delta
	if alpha > alphaMax:
		alphaUp = false
	elif alpha < alphaMin:
		alphaUp = true
	if attack >= attackMax:
		$Attack.tint_progress.a = alpha
	else:
		$Attack.tint_progress.a = 1
	if attackActive:
		$Attack.tint_under.a = alpha
		$Defend.tint_under.a = 0
	else:
		$Attack.tint_under.a = 0
		$Defend.tint_under.a = alpha
	$Defend.value = shield
	$Attack.value = attack
	$Score.text = str(score) + "\nx" + str(multiplier)
	$enemyWizard.visible = enemyWizard
	$attackCharge.pitch_scale = .75 + attack/attackMax

func score(points):
	score += points * multiplier

func miss():
	attack = 0
	$charged.pitch_scale = .5
	$charged.play()

func hitWizard():
	$enemyTarget.stop()
	$enemyAttack.stop()
	$enemyLeave.stop()
	$enemyLeft.stop()
	$enemyWizardAttack.stop()
	$enemyWizardSpawn.stop()
	$enemyWizardCharge.stop()
	$enemyWizardLeave.stop()
	$enemyHit.start()
	$enemyWizardExplode.play()
	$enemyWizard.animation = "hit"
	enemyTargetable = false

func _on_perSecondTimer_timeout():
	score(pointsPerSecond)
	if multiplier < maxMultiplier:
		multiplier += multiplierIncrement


func _on_enemySpawn_timeout():
	enemyWizard = true
	$enemyTarget.start()
	$enemyWizard.animation = "idle"
	$enemyWizardSpawn.play()

func _on_enemyTarget_timeout():
	if witchVisits % 2 == 0 and dialog:
		dialogPopup()
	witchVisits += 1
	enemyTargetable = true
	$enemyWizard.animation = "charging"
	$enemyWizardCharge.play()
	$enemyAttack.start()

func _on_enemyAttack_timeout():
	$enemyWizard.animation = "attack"
	emit_signal("enemyAttack")
	$enemyWizardAttack.play()
	$enemyLeave.start()

func _on_enemyLeave_timeout():
	$enemyWizard.animation = "leaving"
	$enemyWizardLeave.play()
	$enemyLeft.start()

func _on_enemyLeft_timeout():
	enemyWizard = false
	enemyTargetable = false
	$enemySpawn.start()


func _on_enemyHit_timeout():
	$enemySpawn.start()
	enemyWizard = false


func _on_charged_finished():
	$charged.pitch_scale = 1
	
func dialogPopup():
	$Dialog.visible = true


func _on_tutShieldTimer_timeout():
	tutCharge = true
