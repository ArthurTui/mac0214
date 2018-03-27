extends "res://spells/base_spell.gd"

const SPEED = 5
const DAMAGE = 15
const KNOCKBACK = 25
const HOMING_FACTOR = 20 # the lowest the factor is, the fastest the homing

var direction = Vector2(0, 0)
var parent

var target
var accel


func fire(direction, parent):
	self.direction = direction
	self.parent = parent
	set_rotation(direction.angle())
	set_position(parent.position)


func _process(delta):
	position += direction * SPEED
	if target != null:
		home()


# Given the conditions, homes in the direction of the target
func home():
	if !weakref(target).get_ref(): # target was freed
		target = null
		return

	var target_pos = target.position
	var dif = target_pos - self.position
	direction += dif.normalized() / HOMING_FACTOR
	
	if direction.x > 1.1:
		direction.x = 1.1
	elif direction.x < - 1.1:
		direction.x = - 1.1

	if direction.y > 1.1:
		direction.y = 1.1
	elif direction.y < - 1.1:
		direction.y = - 1.1


# does damage if take damage function exists in body
func _on_projectile_body_entered(body):
	if body != parent:
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE, self.direction, KNOCKBACK)
		die()


func _on_detection_area_body_entered(body):
	if body.is_in_group("Player") and body != parent:
		target = body
		$detection_area.queue_free()


func _on_lifetime_timeout():
	die()


func die():
	$projectile.queue_free()
	$lifetime.queue_free()
	$anim.play("death")
	set_process(false)


func free_scn():
	queue_free()