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

init_entities :: proc() {
	world.entities = make([dynamic]Entity, 0, 16)
	column := Entity {
		tag         = .Column,
		rotation    = l.QUATERNIONF32_IDENTITY,
		scale       = {1, 20, 1},
		translation = {0, 0, 0},
	}
	append(&world.entities, column)
	world.camera.lockon_target = &world.entities[0]
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
