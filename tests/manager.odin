package tests

import g ".."
import "core:testing"


@(test)
entities_add_raw :: proc(t: ^testing.T) {
	entities: g.Entity_Manager
	entities.used[0] = true
	entities.empty_slot = 1
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
}
