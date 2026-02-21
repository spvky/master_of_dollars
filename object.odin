package main

import rl "vendor:raylib"

Object_Data :: struct {
	kind: Object_Kind,
}

Object_Kind :: union {
	Grenade_Data,
}

Grenade_Data :: struct {
	active: bool,
	timer:  f32,
}

spawn_grenade :: proc(entities: ^Entity_Manager, pos: Vec2) {
	grenade := Entity {
		rigidbody = {pos = pos, speed = 0},
		traits = {.Throwable, .Grabable, .Auto_Pickup},
		kind = Object_Data{kind = Grenade_Data{active = false, timer = 1}},
	}
	add(entities, grenade)
}

render_object :: proc(e: Entity, o: Object_Data) {
	switch v in o.kind {
	case Grenade_Data:
		rl.DrawCircleV(e.rigidbody.pos, 2, rl.GOLD)
	}
}
