extends "res://spells/base_spell.gd"

const TRAIL_LENGTH = 20
const TRAIL_OFFSET = 2.5

func cast(caster, direction):
	.cast(caster, direction)
	set_rotation(direction.angle())


func _process(delta):
	if !dying:
		# Update position
		position += direction * speed
		# Add trail point
		var offset = Vector2(TRAIL_OFFSET * direction.y * rand_range(-1, 1),
			TRAIL_OFFSET * direction.x * rand_range(-1, 1))
		$Trail.add_point(position + offset)
	elif $Trail.get_point_count() > 0:
		$Trail.remove_point(0)
	
	# Update trail
	$Trail.global_position = Vector2()
	$Trail.global_rotation = 0
	if $Trail.get_point_count() > TRAIL_LENGTH:
		$Trail.remove_point(0)


func die():
	if dying:
		return
	.die()
	$Projectile/Shape.disabled = true
	$Lifetime.stop()
	death_animation()


func death_animation():
	# Animation duration
	var dur = .4
	
	$Tween.interpolate_property($Sprite, "scale", $Sprite.scale,
		Vector2(1.5, 1.5), dur, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate,
		Color(1, 1, 1, 0), dur, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.interpolate_property($Trail, "modulate", $Trail.modulate,
		Color(1, 1, 1, 0), dur, Tween.TRANS_QUAD, Tween.EASE_IN)
	$Tween.start()


func _on_Lifetime_timeout():
	die()


func _on_Tween_tween_completed(object, key):
	queue_free()
