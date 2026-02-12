package main

import rl "vendor:raylib"

world: World

World :: struct {
	camera:   rl.Camera2D,
	entities: Entity_Manager,
}


init_world :: proc() {
	world.camera = rl.Camera2D {
		zoom = 1,
	}
}
