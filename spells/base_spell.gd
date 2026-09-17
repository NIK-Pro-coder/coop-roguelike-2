class_name Spell extends Item

@export var soul_cost: float = 0.0

func cast_spell(player: Player):
  if player.soul >= soul_cost:
    return
  
  var did_cast: bool = _spell(player)
  
  if did_cast:
    player.soul -= soul_cost

@warning_ignore("unused_parameter")
func _spell(player: Player) -> bool:
  return false
