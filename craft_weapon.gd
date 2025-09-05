extends Area3D

@onready var player = $"../Player"
@onready var progress_bar : ProgressBar = $Hud_craft_weapon/ProgressBar
@onready var sword_sc = preload('res://Scene_Obj/sword.tscn')
var put_action = false
var item_on = false
var item_slot0 = false
var item_slot1 = false


func _process(delta: float) -> void:
	if item_slot0 and item_slot1:
		sword_crafted()

func _on_body_entered(body: Node3D) -> void:
	if body == player:
		put_action = true
		
func _on_body_exited(body: Node3D) -> void:
	if body == player:
		put_action = false

func _on_player_get_item() -> void:
	if  item_slot0 and not item_slot1 :
		_on_player_put_item()
	if  item_slot1 and not item_slot0 :
		_on_player_put_item()
	elif put_action and not player.carrying and not player.obj_carrying :
		if item_slot0:
			var got_obj: RigidBody3D = null
			for i in $craft_weapon_carry0.get_children(): #usa o for para navegar entre os filhos(.get_children()) 
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
				item_slot0 = false
		if item_slot1:
			var got_obj: RigidBody3D = null
			for i in $craft_weapon_carry1.get_children(): #usa o for para navegar entre os filhos(.get_children()) 
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
				item_slot1 = false
#COLOCAR OS 2 OBJETOS NO MSM LUGAR NA MESMA HORA OLHAR AMANHA
func _on_player_put_item() -> void:
	if put_action and player.carrying and not item_slot0:
		var puted_obj = player.obj_carrying
		if puted_obj:
			puted_obj.call_deferred('reparent' , $craft_weapon_carry0, true) #chamando o reparent par passar o obj para a mesa
			call_deferred('puted_obj_reposition0', puted_obj)
			player.obj_carrying = null
			player.carrying = false
			player.holding = false
			item_on = true
			item_slot0 = true
	if put_action and player.carrying and item_slot0:
		var puted_obj = player.obj_carrying
		if puted_obj:
			puted_obj.call_deferred('reparent' , $craft_weapon_carry1, true) #chamando o reparent par passar o obj para a mesa
			call_deferred('puted_obj_reposition1', puted_obj)
			player.obj_carrying = null
			player.carrying = false
			player.holding = false
			item_on = true
			item_slot1 = true

func puted_obj_reposition0(item : RigidBody3D) -> void:
	item.position = $craft_weapon_carry0.position
	item.rotation = $craft_weapon_carry0.rotation
	
	
func puted_obj_reposition1(item : RigidBody3D) -> void:
	item.position = $craft_weapon_carry1.position
	item.rotation = $craft_weapon_carry1.rotation
	

func puted_obj_reposition_crafted(item : RigidBody3D):
	item.position = $crafted_weapon_carry.position
	item.rotation = $crafted_weapon_carry.rotation

func puted_obj_reposition_carry(item : RigidBody3D) -> void:
	item.position = player.aim.position
	
func sword_crafted():
	var got_obj0: RigidBody3D = null
	var got_obj1: RigidBody3D = null
	for i in $craft_weapon_carry0.get_children(): #usa o for para navegar entre os filhos(.get_children()) 
		if i is RigidBody3D:
			if got_obj0 == null:
				got_obj0 = i
	for i in $craft_weapon_carry1.get_children(): #usa o for para navegar entre os filhos(.get_children()) 
		if i is RigidBody3D:
			if got_obj1 == null:
				got_obj1 = i
		print(got_obj0 , got_obj1)
	if got_obj0.is_in_group(&'Ore') and got_obj1.is_in_group(&'Wood') or got_obj0.is_in_group(&'Wood') and got_obj1.is_in_group(&'Ore') :
		got_obj0.queue_free() 
		got_obj1.queue_free()
		item_slot0 = false
		item_slot1 = false
		var sword = sword_sc.instantiate()
		get_tree().get_current_scene().add_child(sword) #colocar o objeto instanciado na cena
		sword.call_deferred('reparent' , $craft_weapon_carry0, true) #chamando o reparent par passar o obj para a mesa
		call_deferred('puted_obj_reposition_crafted', sword)
		sword.freeze = true
		item_slot0 = true 
	else:
		print('receita wrong')
