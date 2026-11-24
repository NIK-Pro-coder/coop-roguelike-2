extends Resource
class_name Room

enum RoomTypes {Normal, Mid, Hard, Twist, Chill, Special, Boss, Start}

func budget_mult() -> float:
  return {
    RoomTypes.Special: 0.0,
    RoomTypes.Start:   0.0,
    RoomTypes.Boss:    0.0,
    RoomTypes.Chill:   0.6,
    RoomTypes.Normal:  1.0,
    RoomTypes.Twist:   1.1,
    RoomTypes.Hard:    1.13,
    RoomTypes.Mid :    1.15,
  }[type]

@export var type: RoomTypes
