extends Resource
class_name Room

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

@export var type: RoomTypes
