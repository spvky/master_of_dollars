package main

import rl "vendor:raylib"

world: World

World :: struct {
	camera:    rl.Camera3D,
	colliders: [dynamic]Collider,
}

init_world :: proc() {
	world.camera = rl.Camera3D {
		up         = VEC_Y,
		fovy       = 45,
		target     = VEC_0,
		position   = {0, 10, 10},
		projection = .PERSPECTIVE,
	}

	world.colliders = make([dynamic]Collider, 0)
}
