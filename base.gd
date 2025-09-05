extends Area3D
var hp = 4
@onready var hp_bar : ProgressBar = $Control/ProgressBar

#func _process(delta: float) -> void:
	#if hp <= 0 :
	
		
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group('minion'):
		hp -= 1
		hp_bar.value -= 20
