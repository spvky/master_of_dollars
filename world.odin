package main

import l "core:math/linalg"

world: World

World :: struct {
	player:     Player,
	camera:     Camera,
	colliders:  [dynamic]Collider,
	entities:   [dynamic]Entity,
	rune_wheel: Rune_Wheel,
}

init_world :: proc() {
	world.camera = Camera {
		rotation = l.QUATERNIONF32_IDENTITY,
		raw = {up = VEC_Y, fovy = 45, target = VEC_0, projection = .PERSPECTIVE},
		mode = .Free,
	}

	world.player = Player{VEC_Z * -10}

	world.colliders = make([dynamic]Collider, 0)
	init_runes()
}
