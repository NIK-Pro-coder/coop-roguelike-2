class_name PlayerMngr extends Node

const PLAYER = preload("uid://dw1078phksnim")

var spawned_players: Array[Player] = []

func _process(_delta: float) -> void:
  for i in Input.get_connected_joypads() + [-1]:
    if !i in spawned_players.map(func(x: Player): return x.device_id) \
    and MultiInput.is_action_pressed("attack", i) :
      var p: Player = PLAYER.instantiate()
      p.device_id = i
      
      Qol.add_to_tree(p)
      spawned_players.append(p)
