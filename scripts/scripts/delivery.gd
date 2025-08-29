extends Area3D

@onready var player = $"../Player"
@onready var spawn_point : Node3D = $"../spawn_ally_minion"
@onready var minion_swordsc = preload("res://Minions/minion_sword.tscn")

var put_action = false


func _on_body_entered(body: Node3D) -> void: #funcao para verificar q o player ta dentro e habilitar fazer a acao
	if body == player:
		put_action = true
	
func _on_body_exited(body: Node3D) -> void: #funcao para verificar q o player ta fora e desabilitar
	if body == player:
		put_action = false

func _on_player_put_item() -> void:
	if put_action and player.carrying and player.obj_carrying:
		var puted_obj = player.obj_carrying
		if puted_obj:
			puted_obj.call_deferred('reparent' , self, true) #chamando o reparent par passar o obj para a mesa
			#call_deferred('puted_obj_reposition', puted_obj)
			player.obj_carrying = null
			player.carrying = false
			player.holding = false
			Spawn_minion()
			puted_obj.queue_free()

func Spawn_minion():
	var minion_sword = minion_swordsc.instantiate()
	get_tree().get_current_scene().add_child(minion_sword) #colocar o objeto instanciado na cena
	#minion_sword.call_deferred('reparent' , spawn_point, true) #chamando o reparent par passar o obj para a mesa
	call_deferred('Posicao_Spawn', minion_sword)
	print('minion spawnado')

func Posicao_Spawn(minion : RigidBody3D):
	minion.position = spawn_point.position
	
