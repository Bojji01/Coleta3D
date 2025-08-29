extends Area3D
var put_action = false #variavel para checar se o player pode fazer a acao
@onready var player = $"../Player"
@onready var hud_woodwork : Control = $Hud_woodwork
@onready var camera : Camera3D = get_viewport().get_camera_3d()
@onready var progress_bar : ProgressBar = $Hud_woodwork/ProgressBar
@onready var wood_handlesc = preload('res://Scene_Obj/wood_handle.tscn')
var crafting = false
var item_craft : RigidBody3D
var item_on = false
var mesh00 : MeshInstance3D
var mesh01 : MeshInstance3D

func _process(delta: float) -> void:
	if crafting and item_on:
		hud_woodwork.visible = true
		var hud_position = camera.unproject_position(global_transform.origin)
		hud_woodwork.position = hud_position + Vector2(-80, -90)
		progress_bar.value += delta  * 50
	
	if not crafting:
		hud_woodwork.visible = false
	
	if crafting and progress_bar.value == 50:
		mesh00.visible = false
		mesh01.visible = true
		
	if crafting and progress_bar.value == 100 :
		item_crafted()
		progress_bar.value = 0
		item_on = false
		hud_woodwork.visible = false
		

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
			item_on = true
			
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
			item_on = false
			
func puted_obj_reposition(item : RigidBody3D) -> void:
	item.position = $mesacarry.position

func puted_obj_reposition_carry(item : RigidBody3D) -> void:
	item.position = player.aim.position

func _on_player_action() -> void:
	if put_action:
		for i in self.get_children():
			if i is RigidBody3D and i.is_in_group(&'wood'):
				crafting = true
				item_craft = i
				mesh00 = item_craft.find_child("wood00") as MeshInstance3D
				mesh01 = item_craft.find_child('wood01') as MeshInstance3D
				
func _on_player_inaction() -> void:
	if put_action:
		crafting = false

func item_crafted():
	var delete_obj: RigidBody3D = null
	for i in self.get_children():   #usa o for para navegar entre os filhos(.get_children()) 
		if i is RigidBody3D:
			delete_obj = i
	if delete_obj:
		delete_obj.queue_free()
	var wood_handle = wood_handlesc.instantiate()
	get_tree().get_current_scene().add_child(wood_handle) #colocar o objeto instanciado na cena
	wood_handle.call_deferred('reparent' , self, true) #chamando o reparent par passar o obj para a mesa
	call_deferred('puted_obj_reposition', wood_handle)
	wood_handle.freeze = true
