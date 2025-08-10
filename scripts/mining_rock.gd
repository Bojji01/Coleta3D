extends StaticBody3D

@onready var player = $"../Player"
@onready var coalsc = preload("res://Scene_Obj/coal.tscn")
var can_hit = false
var mine_life = 3
var hit = 1

func _ready() -> void:
	player.interact.connect(_on_player_interact) # conectar o signal dirtetamente via script

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		can_hit = true
		
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body == player:
		can_hit = false
		
func _on_player_interact() -> void:
	if can_hit and not player.carrying:
		mine_life = mine_life - hit #mecaninca de hit mine
		if mine_life <= 0:
			mined() 
			
func mined(): #destroi o mina e spawna o carvao
	var coal = coalsc.instantiate()
	get_tree().get_current_scene().add_child(coal)
	coal.global_transform.origin = self.global_transform.origin
	coal.apply_impulse(Vector3.UP * 3)
	self.queue_free()
