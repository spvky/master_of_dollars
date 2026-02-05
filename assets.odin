package main

import rl "vendor:raylib"

assets: Assets

Assets :: struct {
	cube:      rl.Model,
	cylinder:  rl.Model,
	crosshair: rl.Texture,
}

init_assets :: proc() {
	cube_mesh := rl.GenMeshCube(1, 1, 1)
	assets.cube = rl.LoadModelFromMesh(cube_mesh)
	cylinder_mesh := rl.GenMeshCylinder(1, 1, 8)
	assets.cylinder = rl.LoadModelFromMesh(cylinder_mesh)
	assets.crosshair = rl.LoadTexture("assets/crosshair.png")
}
