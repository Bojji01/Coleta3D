extends Area3D
var put_action = false #variavel para checar se o player pode fazer a acao
@onready var player = $"../Player"
var mesacarry = Node3D

func _ready() -> void:
	mesacarry = $mesacarry
	
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
			call_deferred('puted_obj_reposition', puted_obj)
			player.obj_carrying = null
			player.carrying = false
			player.holding = false
			
func _on_player_get_item() -> void:
	if put_action and not player.carrying and not player.obj_carrying :
		var got_obj: RigidBody3D = null
		for i in self.get_children(): #usa o for para navegar entre os filhos(.get_children()) 
			if i is RigidBody3D:
				got_obj = i
		if got_obj:
			got_obj.call_deferred('reparent', player.carry_position, true) #passando o obj para o player dnv
			call_deferred('puted_obj_reposition_carry' , got_obj)
			player.obj_carrying = got_obj
			player.carrying = true
			player.holding = true
		
func puted_obj_reposition(item : RigidBody3D) -> void:
	item.position = $mesacarry.position

func puted_obj_reposition_carry(item : RigidBody3D) -> void:
	item.position = player.aim.position
