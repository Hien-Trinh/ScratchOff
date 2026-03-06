extends Node2D

var scratch_points := PackedVector2Array()
var brush_size: float = 30.0 # Adjust thickness of the coin/eraser

func add_scratch_point(pos: Vector2) -> void:
	scratch_points.append(pos)
	queue_redraw()

func clear_scratch() -> void:
	scratch_points.clear()
	queue_redraw()

func _draw() -> void:
	if scratch_points.size() == 0: return
	if scratch_points.size() == 1:
		draw_circle(scratch_points[0], brush_size / 2.0, Color.WHITE)
		return

	# Draw thick lines between all recorded mouse points
	for i in range(1, scratch_points.size()):
		var p1 = scratch_points[i-1]
		var p2 = scratch_points[i]
		draw_line(p1, p2, Color.WHITE, brush_size, true)
		draw_circle(p1, brush_size / 2.0, Color.WHITE) # Rounds off the line joints

	draw_circle(scratch_points[-1], brush_size / 2.0, Color.WHITE)
