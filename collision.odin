package main

import "core:fmt"
import "core:math"
import l "core:math/linalg"
import rl "vendor:raylib"

Quat :: l.Quaternionf32

Transform :: struct {
	translation: Vec3,
	scale:       Vec3,
	rotation:    Quat,
	angle:       f32,
	c_value:     f32,
}

Collider :: struct {
	using transform: Transform,
}

Polygon :: struct {
	local_points: [8]Vec3,
	rotation:     quaternion128,
	origin:       Vec3,
}


make_cube :: proc(origin: Vec3, extents: Vec3, rotation: quaternion128) -> (poly: Polygon) {
	half_extents := extents / 2
	poly.local_points = {
		//Front Face
		half_extents,
		{-half_extents.x, half_extents.y, half_extents.z},
		{-half_extents.x, -half_extents.y, half_extents.z},
		{half_extents.x, -half_extents.y, half_extents.z},
		// Back Face
		{half_extents.x, -half_extents.y, -half_extents.z},
		{half_extents.x, half_extents.y, -half_extents.z},
		{-half_extents.x, half_extents.y, -half_extents.z},
		-half_extents,
	}
	poly.origin = origin
	poly.rotation = rotation
	return
}

get_points :: proc(polygon: Polygon) -> (points: [8]Vec3) {
	for p, i in polygon.local_points {
		points[i] = l.quaternion128_mul_vector3(polygon.rotation, p) + polygon.origin
	}
	return
}

draw_polygon :: proc(polygon: Polygon) {
	points := get_points(polygon)
	for i in 0 ..< 7 {
		rl.DrawLine3D(points[i], points[i + 1], rl.RED)
	}
	rl.DrawLine3D(points[7], points[0], rl.RED)
}


draw_colliders :: proc() {
	for collider in world.colliders {
		rl.DrawCubeWiresV(collider.translation, collider.scale, rl.RED)
	}
}
