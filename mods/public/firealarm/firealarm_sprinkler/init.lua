sprinkler.active_heads = sprinkler.active_heads or {}

minetest.register_privilege("sprinkler",{
	description = "To fix a firealarm sprinkler device",
	give_to_singleplayer = true,
})

minetest.register_node(":firealarm:sprinkler_head",{
	description = "Sprinkler Head",
	groups = { oddly_breakable_by_hand = 1 },
	tiles = {
		"firealarm_sprinkler_head_top_bottom.png",
		"firealarm_sprinkler_head_top_bottom.png",
		"firealarm_sprinkler_head_side.png",
		"firealarm_sprinkler_head_side.png",
		"firealarm_sprinkler_head_side.png",
		"firealarm_sprinkler_head_side.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.093375,0.45,-0.0625,0.0625,0.5,0.093375},
			{-0.025625,0.3,-0.01,0.005625,0.45,0.03},

			{-0.093375,0.3,-0.0625,-0.085,0.45,-0.055},
			{-0.093375,0.3,0.085,-0.085,0.45,0.093375},
			{0.055,0.3,-0.0625,0.0625,0.45,-0.055},
			{0.055,0.3,0.085,0.0625,0.45,0.093375},

			{-0.093375,0.275,-0.0625,0.0625,0.3,0.093375},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	after_place_node = function(pos)
		sprinkler.setDevInfo("signaling",pos,{active = false})
	end,
	after_dig_node = function(pos)
		sprinkler.setDevInfo("signaling",pos,nil)
	end,
})

minetest.register_node(":firealarm:sprinkler_head_on",{
	drop = "firealarm:sprinkler_head",
	description = "Sprinkler Head (you hacker you!)",
	groups = { oddly_breakable_by_hand = 1, not_in_creative_inventory = 1},
	tiles = {
		"firealarm_sprinkler_head_top_bottom.png",
		"firealarm_sprinkler_head_top_bottom.png",
		"firealarm_sprinkler_head_side.png",
		"firealarm_sprinkler_head_side.png",
		"firealarm_sprinkler_head_side.png",
		"firealarm_sprinkler_head_side.png",
	},
	paramtype = "light",
	paramtype2 = "facedir",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.093375,0.45,-0.0625,0.0625,0.5,0.093375},
			{-0.025625,0.44,-0.01,0.005625,0.45,0.03},
			{-0.025625,0.3,-0.01,0.005625,0.31,0.03},

			{-0.093375,0.3,-0.0625,-0.085,0.45,-0.055},
			{-0.093375,0.3,0.085,-0.085,0.45,0.093375},
			{0.055,0.3,-0.0625,0.0625,0.45,-0.055},
			{0.055,0.3,0.085,0.0625,0.45,0.093375},

			{-0.093375,0.275,-0.0625,0.0625,0.3,0.093375},
		},
	},
	on_punch = function(pos,_,player)
		local name = player:get_player_name()
		minetest.chat_send_player(name,string.format("Position: %d,%d,%d",pos.x,pos.y,pos.z))
	end,
	on_rightclick = function(pos,node,clicker)
		if minetest.is_protected(pos,clicker:get_player_name()) and not minetest.check_player_privs(clicker,"protection_bypass") then
			minetest.record_protection_violation(pos,clicker:get_player_name())
			minetest.chat_send_player(clicker:get_player_name(),"You are not authorized to reset this pull station")
			return
		end
		local devInfo = sprinkler.getDevInfo("signaling",pos)
		if devInfo then
			devInfo.active = false
			node.name = "firealarm:sprinkler_head"
			minetest.set_node(pos,node)
			minetest.sound_play("firealarm_sprinkler_head_reset",{pos=pos})
                        sprinkler.active_heads[minetest.hash_node_position(pos)] = nil
		end
	end,
	after_dig_node = function(pos)
		sprinkler.setDevInfo("signaling",pos,nil)
                sprinkler.active_heads[minetest.hash_node_position(pos)] = nil
	end,
})

minetest.register_abm({
    label = "Sprinkler Detection",
    nodenames = {"firealarm:sprinkler_head"},
    interval = 5,
    chance = 1,
    action = function(pos, node)
        local fire_nodes = {
            "fire:basic_flame",
            "fire:permanent_flame",
            "default:lava_source",
            "default:lava_flowing"
        }

        local minp = vector.add(pos, {x=-4,y=-4,z=-4})
        local maxp = vector.add(pos, {x= 4,y= 4,z= 4})

        if #minetest.find_nodes_in_area(minp, maxp, fire_nodes) > 0 then
            local devInfo = sprinkler.getDevInfo("signaling", pos)

            if not devInfo or devInfo.active then
                return
            end

            devInfo.active = true

            sprinkler.setDevInfo("signaling", pos, devInfo)

            sprinkler.sprinkler_effect(pos)
            sprinkler.active_heads[minetest.hash_node_position(pos)] = pos

            node.name = "firealarm:sprinkler_head_on"
            minetest.swap_node(pos, node)

            minetest.sound_play("firealarm_sprinkler_head_break",{pos=pos})
        end
    end,
})

minetest.register_craft({
	output = "firealarm:sprinkler_head",
	recipe = {
		{"","default:steelblock","",},
		{"dye:red","default:glass","dye:red",},
		{"","default:steelblock","",},
	}
})

function sprinkler.sprinkler_effect(pos)
    minetest.add_particlespawner({
        amount = 25,
        time = 0.25,
        minpos = vector.add(pos, {x=-0.3, y=0.4, z=-0.3}),
        maxpos = vector.add(pos, {x=0.3, y=0.5, z=0.3}),
        minvel = {x=-1, y=2, z=-1},
        maxvel = {x=1, y=4, z=1},
        minacc = {x=0, y=-9.8, z=0},
        maxacc = {x=0, y=-9.8, z=0},
        minexptime = 0.5,
        maxexptime = 1.2,
        texture = "glass.png",
        glow = 1
    })
end

minetest.register_globalstep(function(dtime)
        sprinkler.timer = (sprinkler.timer or 0) + dtime
        if sprinkler.timer < 1 then return end
        sprinkler.timer = 0
        for hash, pos in pairs(sprinkler.active_heads) do
                if pos and pos.x and pos.y and pos.z then
                        sprinkler.sprinkler_effect_tick(pos)
                else
                    sprinkler.active_heads[hash] = nil
                end
        end
end)

function sprinkler.sprinkler_effect_tick(pos)
    local radius = 4

    minetest.add_particlespawner({
            amount = 100,
            time = 1.25,
            minpos = vector.add(pos, {x=-0.3, y=0.4, z=-0.3}),
            maxpos = vector.add(pos, {x=0.3, y=0.5, z=0.3}),
            minvel = {x=-5, y=0, z=-5},
            maxvel = {x=5, y=0, z=5},
            minacc = {x=0, y=-9.8, z=0},
            maxacc = {x=0, y=-9.8, z=0},
            minexptime = 0.5,
            maxexptime = 1.2,
            texture = "water.png",
            glow = 1
    })

    minetest.sound_play("firealarm_sprinkler_head_flow",{pos=pos})

    for px = -radius, radius do
    for py = -radius, radius do
    for pz = -radius, radius do
        local p = vector.add(pos, {x=px, y=py, z=pz})
        local node = minetest.get_node(p)

        local fire_nodes = {
            ["fire:basic_flame"] = "air",
            ["fire:permanent_flame"] = "air",
            ["default:lava_source"] = "default:stone",
            ["default:lava_flowing"] = "default:stone"
        }
        local replacement = fire_nodes[node.name]
        if replacement then
            if not (p.x == pos.x and p.z == pos.z and p.y > pos.y) then
                minetest.set_node(p, {name = replacement})
            end
        end
    end
    end
    end
end