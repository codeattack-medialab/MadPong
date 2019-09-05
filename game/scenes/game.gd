extends Node

var score1 := 0
var score2 := 0

func _ready():
	$Racket1.player = 1
	$Racket2.player = 2
	$Score1.text = "0"
	$Score2.text = "0"

	$Racket1.set_field_limits($Limits/TopLeft.position.x, $Limits/BottomRight.position.x)
	$Racket2.set_field_limits($Limits/TopLeft.position.x, $Limits/BottomRight.position.x)

#		$"/root/Game".score1+=1
#		$"/root/Game/Score1".text= str($"/root/Game".score1)



