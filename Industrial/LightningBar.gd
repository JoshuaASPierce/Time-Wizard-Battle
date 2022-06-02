extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var trapOn = false
export var minStart = 1
export var maxStart = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$ChargeTime.start(rand_range(minStart, maxStart))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ChargeTime_timeout():
	$Charge.visible = true
	$LightTime.start()


func _on_LightTime_timeout():
	$Charge.visible = false
	$Lightning.visible = true
	trapOn = true
	$DeadTime.start()


func _on_DeadTime_timeout():
	$Lightning.visible = false
	trapOn = false
	$ChargeTime.start()


func _on_LightningBar_body_entered(body):
	if body.is_in_group('character') and trapOn:
		body.death(false)
