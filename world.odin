package main

import l "core:math/linalg"
import rl "vendor:raylib"

world: World

World :: struct {
	camera:    Camera,
	colliders: [dynamic]Collider,
}

init_world :: proc() {
	world.camera = Camera {
		rotation = l.QUATERNIONF32_IDENTITY,
		raw = {up = VEC_Y, fovy = 45, target = VEC_0, projection = .PERSPECTIVE},
	}

	world.colliders = make([dynamic]Collider, 0)
}
