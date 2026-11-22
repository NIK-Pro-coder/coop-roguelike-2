extends Resource
class_name Map

enum RoomTypes {
  Normal,
  Mid,
  Hard,
  Twist,
  Chill,
  Special,
  Boss,
  Start
}

@export var encounters: Array[RoomTypes] = []
@export var edges: Dictionary[int, PackedInt64Array] = {}
