package main

import l "core:math/linalg"
import rl "vendor:raylib"

Entity :: struct {
	using transform: Transform,
	tag:             Entity_Tag,
}

Entity_Tag :: enum {
	Column,
	Crate,
}


Transform :: struct {
	translation: Vec3,
	scale:       Vec3,
	rotation:    Quat,
}

entity_center :: proc(entity: Entity) -> (center: Vec3) {
	switch entity.tag {
	case .Crate:
	case .Column:
		center = entity.translation + (VEC_Y * (entity.scale.y / 2))
	}
	return center
}

init_entities :: proc() {
	world.entities = make([dynamic]Entity, 0, 16)
	append(&world.entities, beige_column({0, -10, 0}))
	append(&world.entities, beige_column({-5, -10, 1}))
	append(&world.entities, beige_column({2, -10, 7}))
	append(&world.entities, beige_column({-4, -10, -3}))
	append(&world.entities, beige_column({10, -10, 0}))
	world.camera.lockon_target = 3
}

beige_column :: proc(translation: Vec3) -> Entity {
	return Entity {
		tag = .Column,
		rotation = l.QUATERNIONF32_IDENTITY,
		scale = {1, 20, 1},
		translation = translation,
	}
}

cleanup_entities :: proc() {
	delete(world.entities)
}

draw_entities :: proc() {
	for e in world.entities {
		angle, axis := l.angle_axis_from_quaternion(e.rotation)
		switch e.tag {
		case .Column:
			rl.DrawModelEx(assets.cylinder, e.translation, axis, angle, e.scale, rl.BEIGE)
		case .Crate:
		}
	}
}
