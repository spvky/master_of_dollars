package tests

import g ".."
import "core:testing"


@(test)
entities_add_raw :: proc(t: ^testing.T) {
	entities: g.Entity_Manager
	g.init_entity_manager(&entities)
	i1 := g.add(&entities, g.Entity{kind = .Player})
	i2 := g.add(&entities, g.Entity{kind = .Object})
	i3 := g.add(&entities, g.Entity{kind = .NPC})
	testing.expectf(t, entities.empty_slot == 4, "Empty slots is actually %v", entities.empty_slot)
	testing.expectf(
		t,
		entities.items[3].kind == .NPC,
		"Entity[3] was  %v not an npc",
		entities.items[3].kind,
	)
}

@(test)
entities_get :: proc(t: ^testing.T) {
	entities: g.Entity_Manager
	g.init_entity_manager(&entities)
	i1 := g.add(&entities, g.Entity{rigidbody = {pos = {12, 14}}})
	i2 := g.add(&entities, g.Entity{rigidbody = {pos = {30, -5}}})
	i3 := g.add(&entities, g.Entity{rigidbody = {pos = {72, 4}}})
	ptr3 := g.get(&entities, 3)
	ptr3.rigidbody.pos.x += 5

	testing.expectf(
		t,
		ptr3.rigidbody.pos.x == 77,
		"Position X was %.2f not 77",
		ptr3.rigidbody.pos.x,
	)
}

@(test)
entities_remove_and_shrink :: proc(t: ^testing.T) {
	entities: g.Entity_Manager
	g.init_entity_manager(&entities)
	i1 := g.add(&entities, g.Entity{rigidbody = {pos = {12, 14}}})
	i2 := g.add(&entities, g.Entity{rigidbody = {pos = {30, -5}}})
	i3 := g.add(&entities, g.Entity{rigidbody = {pos = {72, 4}}})

	testing.expectf(t, entities.count == 3, "Entity count is %v, not 3", entities.count)
	testing.expectf(
		t,
		entities.empty_slot == 4,
		"Last slot was actually %v instead of 4",
		entities.empty_slot,
	)
	g.remove(&entities, 2)
	testing.expectf(t, entities.count == 2, "Entity count is %v, not 2", entities.count)
	pt2 := g.get(&entities, 2)
	testing.expectf(t, pt2.rigidbody.pos.x == 72, "Pos was actually %v", pt2.rigidbody.pos.x)
	testing.expectf(
		t,
		entities.empty_slot == 3,
		"Last slot was actually %v instead of 3",
		entities.empty_slot,
	)
}
