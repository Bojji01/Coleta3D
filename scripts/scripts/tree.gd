extends StaticBody3D

@onready var player = $"../Player"
@onready var woodsc = preload('res://Scene_Obj/wood.tscn')
var can_hit = false
var tree_life = 3
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
		tree_life = tree_life - hit #mecaninca de hit tree
		if tree_life <= 0:
			fell() 

func fell():
	var wood = woodsc.instantiate()
	get_tree().get_current_scene().add_child(wood)
	wood.global_transform.origin = self.global_transform.origin
	wood.apply_impulse(Vector3.UP * 3)
	self.queue_free()
