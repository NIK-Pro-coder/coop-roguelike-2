extends Resource
class_name EnemyData

@export var name: String = ""
@export var collision: Shape2D

@export_category("Spawning")
@export var budget_cost: float = 0.0
@export var minimum_stage: int = 0
@export var spawn_weight: float = 1.0

@export_category("Stats")
@export var health: int = 0
@export var speed: float = 0
@export var damage: int = 0
@export var knockback_resist: float = 0.0

@export_category("Visuals")
@export var sprite_frames: SpriteFrames
@export var scale: Vector2 = Vector2.ONE

@export_category("Attack Params")
@export var windup: float = 0.0
@export var cooldown: float = 0.0
@export var atk_range: float = 0.0
@export var token_weight: int = 1
@export var has_contact_damage: bool = false

@export_category("Behaviour")
@export var states: Array[BaseEnemyState] = []
