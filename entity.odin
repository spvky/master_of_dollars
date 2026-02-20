package main

import "core:log"
import rl "vendor:raylib"

Idx :: distinct u16

Entity :: struct {
	rigidbody:    Rigidbody,
	traits:       bit_set[Entity_Trait;u64],
	state:        bit_set[Entity_State],
	kind:         Entity_Kind,
	allignment:   Entity_Allignment,
	target:       Idx,
	prev_idx:     Idx,
	curr_idx:     Idx,
	parent_idx:   Idx,
	child_idx:    Idx,
	prev_sib_idx: Idx,
	next_sib_idx: Idx,
}

Entity_Trait :: enum u64 {
	Character,
	Auto_Pickup,
	Grabable,
	Pocketable,
	Throwable,
}

Entity_State :: enum u16 {
	Dead,
	Stunned,
	Burning,
	Wet,
}

Entity_Allignment :: enum {
	Neutral,
	Friendly,
	Hostile,
}

Entity_Kind :: enum {
	Player,
	NPC,
	Object,
}

entity_movement :: proc(delta: f32) {
	entities := &world.entities
	for i in 1 ..< entities.empty_slot {
		if entities.used[i] {
			rb := &entities.items[i].rigidbody
			rb.pos += rb.m_delta * rb.speed * delta
		}
	}
}

entity_idx_tracking :: proc() {
	entities := &world.entities
	for i in 1 ..< entities.empty_slot {
		if entities.used[i] {
			e := &entities.items[i]
			e.prev_idx = e.curr_idx
			e.curr_idx = i

			//Handle idx mismatch here after movement
		}
	}
}

render_entities :: proc() {
	entities := world.entities
	for i in 1 ..< entities.empty_slot {
		if entities.used[i] {
			e := entities.items[i]
			rl.DrawCircleV(e.rigidbody.pos, 50, rl.BLUE)
		}
	}

}
