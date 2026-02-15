## Hitbox / Hurtbox System
## Use Area2D nodes. A "Hitbox" deals damage, a "Hurtbox" receives it.
## Put hitboxes on collision layer 5, hurtboxes monitor layer 5.

# ============ hitbox.gd ============
# Attach to an Area2D named "Hitbox" (child of attacker).

extends Area2D
class_name Hitbox

@export var damage: float = 10.0
@export var knockback_force: float = 200.0


# ============ hurtbox.gd ============
# Attach to an Area2D named "Hurtbox" (child of defender).
# The parent should have a HealthComponent child.

#extends Area2D
#class_name Hurtbox
#
#signal hit_received(hitbox: Hitbox)
#
#@export var invincible: bool = false
#
#
#func _ready() -> void:
#	area_entered.connect(_on_area_entered)
#
#
#func _on_area_entered(area: Area2D) -> void:
#	if invincible:
#		return
#	if area is Hitbox:
#		hit_received.emit(area)
#		# Auto-apply damage if HealthComponent exists on parent
#		var health = get_parent().get_node_or_null("HealthComponent")
#		if health and health.has_method("take_damage"):
#			health.take_damage(area.damage)
#		# Apply knockback
#		if area.knockback_force > 0 and get_parent() is CharacterBody2D:
#			var dir = (get_parent().global_position - area.global_position).normalized()
#			get_parent().velocity = dir * area.knockback_force


# ============ Collision Layer Setup ============
# Hitbox: Layer 5 ON, Mask OFF
# Hurtbox: Layer OFF, Mask 5 ON (monitors hitboxes)
# This way hitboxes don't detect each other, and hurtboxes find hitboxes.
