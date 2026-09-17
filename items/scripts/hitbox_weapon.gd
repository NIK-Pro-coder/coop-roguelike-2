@tool
class_name HitboxWeaponItem extends WeaponItem

enum HitboxType {
  Rectangle,
  Circle
}

@export var hitbox_lifetime: float = -1
@export var distance: float = 50
@export var hitstun: float = 0.0
@export var stick_to_player: bool = true
@export var hitbox_type: HitboxType
@export var hitbox_size: Vector2 = Vector2(20, 20)
@export var hitbox_radius: float = 20

func attack(player: Player, direction: Vector2) -> void:
  var s: Shape2D
  
  if hitbox_type == HitboxType.Rectangle:
    s = Qol.rectangle_shape(hitbox_size.x, hitbox_size.y)
  else:
    s = Qol.circle_shape(hitbox_radius)
  
  var h := Qol.create_hitbox(s)
  
  if stick_to_player:
    player.add_child(h)
  else:
    Qol.add_to_tree(h)
  
  h.lifetime = hitbox_lifetime
  h.rotation = direction.angle() + PI / 2.0
  h.global_position = player.global_position + direction * distance
  h.damage = damage
  h.hitstun = hitstun
