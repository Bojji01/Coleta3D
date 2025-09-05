extends Area3D
@onready var player =  $"../Player"
@onready var hud_Anvil : Control = $Hud_Anvil
@onready var progress_bar : ProgressBar = $Hud_Anvil/ProgressBar
@onready var cooper_bar_sc = preload("res://Scene_Obj/cooper_bar.tscn")
@onready var camera : Camera3D = get_viewport().get_camera_3d()
var item_craft : RigidBody3D
var crafting = false
var put_action = false
var item_on = false
var mesh00 : MeshInstance3D
var mesh01 : MeshInstance3D

func _process(delta: float) -> void:
	if crafting and item_on:
		hud_Anvil.visible = true
		var hud_position = camera.unproject_position(global_transform.origin)
		hud_Anvil.position = hud_position + Vector2(-80, -90)
		progress_bar.value += delta  * 50
	if not crafting:
		hud_Anvil.visible = false
	
	if crafting and progress_bar.value == 50:
		mesh00.visible = false
		mesh01.visible = true
		
	if crafting and progress_bar.value == 100 :
		item_crafted()
		progress_bar.value = 0
		item_on = false
		hud_Anvil.visible = false
		

func _on_body_entered(body: Node3D) -> void:
	if body == player:
		put_action = true

func _on_body_exited(body: Node3D) -> void:
	if body == player:
		put_action = false

func _on_player_put_item() -> void:
	if put_action and player.carrying:
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
			progress_bar.value = 0

func puted_obj_reposition(item : RigidBody3D) -> void:
	item.position = $anvil_carry.position
	item.rotation = $anvil_carry.rotation
	
func puted_obj_reposition_carry(item : RigidBody3D) -> void:
	item.position = player.aim.position

func _on_player_action() -> void:
	if put_action:
		for i in self.get_children():
			if i is RigidBody3D and i.is_in_group(&'Ore') and i.heated: #is_in_group to check the ore dif coal
				crafting = true
				item_craft = i
				mesh00 = item_craft.find_child("ore") as MeshInstance3D
				mesh01 = item_craft.find_child('ore01') as MeshInstance3D
				
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
	var cooper_bar = cooper_bar_sc.instantiate()
	get_tree().get_current_scene().add_child(cooper_bar) #colocar o objeto instanciado na cena
	cooper_bar.call_deferred('reparent' , self, true) #chamando o reparent par passar o obj para a mesa
	call_deferred('puted_obj_reposition', cooper_bar)
	cooper_bar.freeze = true
