extends Node

@warning_ignore_start("unused_signal")
signal room_entered(room: Room)
signal room_cleared(room: Room)

signal wave_started()
signal wave_cleared()
@warning_ignore_restore("unused_signal")
