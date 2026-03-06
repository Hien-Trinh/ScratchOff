extends Node2D

var scratch_points := PackedVector2Array()
var brush_size: float = 30.0 # Adjust thickness of the coin/eraser

const pen_up := Vector2(-9999, -9999)

func add_scratch_point(pos: Vector2) -> void:
	scratch_points.append(pos)
	queue_redraw()

func break_line() -> void:
	# Set impossible coords to send "pen up" signal
	scratch_points.append(pen_up)

func clear_scratch() -> void:
	scratch_points.clear()
	queue_redraw()

# Paint white onto a black ScratchBounds, if pixel is white then turn foil transparent
func _draw() -> void:
	if scratch_points.size() == 0: return

	# Draw thick lines between all recorded mouse points
	for i in range(1, scratch_points.size()):
		var p1 = scratch_points[i-1]
		var p2 = scratch_points[i]

		draw_circle(p1, brush_size / 2.0, Color.WHITE)

		# If either point is our "pen up" signal, skip drawing this line
		if p1 == pen_up or p2 == pen_up:
			continue
	
		draw_line(p1, p2, Color.WHITE, brush_size, true)

	if scratch_points[-1] != pen_up:
		draw_circle(scratch_points[-1], brush_size / 2.0, Color.WHITE)
