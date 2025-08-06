--[[
   Modifed: 28.09.2019 Sokomine (see README)

   3D Forniture
   
   Copyright 2012 Tonyka
   
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
   MA 02110-1301, USA.
   
   Contributors:

    InfinityProject

        suggested creating bathroom kit.

    cosarara97

        code.
   
]]--


	-- Deco Home

		--Table
		minetest.register_node("3dforniture:table",
			{description = 'Table',
			tiles = {
				"forniture_wood.png",
				"forniture_wood.png",
				"forniture_wood_s1.png",
				"forniture_wood_s1.png",
				"forniture_wood_s2.png",
				"forniture_wood_s2.png",
			},
			drawtype = "nodebox",
			sunlight_propagates = true,
			paramtype = 'light',
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.4,-0.5,-0.4, -0.3,0.4,-0.3},
					{0.3,-0.5,-0.4, 0.4,0.4,-0.3},
					{-0.4,-0.5,0.3, -0.3,0.4,0.4},
					{0.3,-0.5,0.3, 0.4,0.4,0.4},
					{-0.5,0.4,-0.5, 0.5,0.5,0.5},
					{-0.4,-0.2,-0.3, -0.3,-0.1,0.3},
					{0.3,-0.2,-0.4, 0.4,-0.1,0.3},
					{-0.3,-0.2,-0.4, 0.4,-0.1,-0.3},
					{-0.3,-0.2,0.3, 0.3,-0.1,0.4},
				},
			},
			groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2}
		})  

		--Chair
		minetest.register_node("3dforniture:chair",
			{ description = 'Chair',
			tiles = {
				"forniture_wood.png",
				"forniture_wood.png",
				"forniture_wood_s1.png",
				"forniture_wood_s1.png",
				"forniture_wood_s2.png",
				"forniture_wood_s2.png",
			},
			drawtype = "nodebox",
			sunlight_propagates = true,
			paramtype = 'light',
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.3,-0.5,0.2, -0.2,0.5,0.3},
					{0.2,-0.5,0.2, 0.3,0.5,0.3},
					{-0.3,-0.5,-0.3, -0.2,-0.1,-0.2},
					{0.2,-0.5,-0.3, 0.3,-0.1,-0.2},
					{-0.3,-0.1,-0.3, 0.3,0,0.2},
					{-0.2,0.1,0.25, 0.2,0.4,0.26}
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
			},
			 groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2}
		})

		--Armchair
		minetest.register_node("3dforniture:armchair",
			{ description = 'Armchair',
			tiles = {
				"forniture_armchair_top.png",
				"forniture_armchair_top.png",
				"forniture_armchair_lat1.png",
				"forniture_armchair_lat1.png",
				"forniture_armchair_lat2.png",
				"forniture_armchair_lat2.png",
			},
			drawtype = "nodebox",
			sunlight_propagates = true,
			paramtype = 'light',
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					--lat 1
					{-0.5,-0.5,-0.45, -0.3,0.05,0.3},
					{-0.45,-0.5,-0.5, -0.35,0.05,-0.45},
					{-0.45,0.05,-0.45, -0.35,0.1,0.15},
					--lat 2
					{0.3,-0.5,-0.45, 0.5,0.05,0.3},{0.35,-0.5,-0.5,0.45,0.05,-0.45},{0.35,0.05,-0.45, 0.45,0.1,0.15},
					--respaldo
					{-0.5,-0.5,0.3, 0.5,0.45,0.5},{-0.45,0.45,0.35,0.45,0.5,0.45},
					--base
					{-0.3,-0.45,-0.35, 0.3,-0.1,0.3},{-0.3,-0.45,-0.4, 0.3,-0.15,-0.35},

					--oreja 1
					{-0.5,0.05,0.15, -0.3,0.45, 0.3},{-0.45,0.1,0.1, -0.35,0.45,0.15},{-0.45,0.45,0.15,-0.35,0.5,0.35},
					--oreja 2
					{0.3,0.05,0.15, 0.5,0.45,0.3},{0.35,0.1,0.1, 0.45,0.45,0.15},{0.35,0.45,0.15,0.45,0.5,0.35},
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
			},
			 groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2}
		})


		--Table Lamp
	lamp_states = {"off", "low", "med", "hi", "max"}
	light_level = 0
	-- not_in_creative_inventory will be set to this value (we only want the FIRST lamp there)
	nocr = 0
	for i, state in ipairs(lamp_states) do
		minetest.register_node("3dforniture:table_lamp_"..state,
			{ description = 'Table Lamp ('..state..')',
			drawtype = "nodebox",
			tiles = {
				"forniture_table_lamp_s.png",
				"forniture_table_lamp_s.png",
				"forniture_table_lamp_l.png",
			},
			 paramtype = 'light',
			paramtype2 == 'facedir',
			 node_box = {
				type = "fixed",
				fixed = {

					--Lamp Base
					{-0.15,-0.5,-0.15, 0.15,-0.45,0.15},
					{-0.05,-0.45,-0.05, 0.05,-0.4,0.05},
					{-0.025,-0.4,-0.025, 0.025,-0.1,0.025},
					{-0.0125,-0.125,-0.2, 0.0125,-0.1,0.2},
					{-0.2,-0.125,-0.0125, 0.2,-0.1,0.0125},

					--Lamp Shade
					{-0.2,-0.1,-0.2, -0.175,0.3,0.2},
					{0.175,-0.1,-0.2, 0.2,0.3,0.2},
					{-0.175,-0.1,-0.2, 0.175,0.3,-0.175},
					{-0.175,-0.1,0.175, 0.175,0.3,0.2},
				},
			},
			sunlight_propagates = true,
			walkable = false,
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.5, 0.5,0.5, 0.5},
			},
			groups = {cracky=2,oddly_breakable_by_hand=1, not_in_creative_inventory=nocr},
			drop = "3dforniture:table_lamp_off",

			light_source = light_level,
			on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				minetest.swap_node(pos,
				    {name="3dforniture:table_lamp_"..lamp_states[i%#lamp_states +1]})
			end,

		})
		light_level = light_level + 4
		nocr = 1
	end

		-- Bathroom Kit

			--Toilet
			minetest.register_node("3dforniture:toilet",
				{ description = 'Toilet',
				tiles = { 
					"forniture_marble.png", "forniture_marble.png", 
					"forniture_marble_s1.png", "forniture_marble_s1.png", 
					"forniture_marble_s2.png", "forniture_marble_s2.png",
				},
				drawtype = "nodebox",
				sunlight_propagates = false,
				paramtype = 'light',
				paramtype2 = "facedir",
				node_box = {
					type = "fixed",
					fixed = {
						{-0.2,-0.5,-0.2, 0.2,-0.45,0.5},
						{-0.1,-0.45,-0.1, 0.1,0,0.5},
						{-0.3,-0.2,-0.3, 0.3,0,0.35},
						{-0.25,0,-0.25, 0.25,0.05,0.25},
						{-0.3,0,0.3, 0.3,0.4,0.5},
						{-0.05,0.4,0.35, 0.05,0.45,0.45},
					},
				},
				drop ="3dforniture:toilet",
				groups = {cracky=3, not_in_creative_inventory=1},
				on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
					minetest.swap_node(pos, {name="3dforniture:toilet_open", param2=node.param2})
				end,
			})

			minetest.register_node("3dforniture:toilet_open",
				{ description = 'Toilet',
				tiles = {
					"forniture_marble_top_toilet.png", "forniture_marble.png",
					"forniture_marble_sb1.png", "forniture_marble_sb1.png",
					"forniture_marble_sb2.png", "forniture_marble_sb2.png",
				},
				drawtype = "nodebox",
				sunlight_propagates = false,
				paramtype = 'light',
				paramtype2 = 'facedir',
				node_box = {
					type = "fixed",
					fixed = {
						{-0.2,-0.5,-0.2, 0.2,-0.45,0.5},
						{-0.1,-0.45,-0.1, 0.1,-0.2,0.5},
						{-0.1,-0.2,0.3, 0.1,0,0.5},
						{-0.3,-0.2,0.1, 0.3,0,0.35},
						{-0.3,-0.2,-0.3, -0.1,-0.15,0.1},
						{-0.1,-0.2,-0.3, 0.1,-0.15,-0.1},
						{0.1,-0.2,-0.3, 0.3,-0.15,0.1},
						{-0.3,-0.15,-0.3, -0.2,0,0.1},
						{-0.2,-0.15,-0.3, 0.2,0,-0.2},
						{0.2,-0.15,-0.3, 0.3,0,0.1},
						{-0.25,0,0.2, 0.25,0.5,0.25},
						{-0.3,0,0.3, 0.3,0.4,0.5},
					},
				},
				drop = "3dforniture:toilet",
				groups = {cracky = 3, not_in_creative_inventory=1},
				on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
					minetest.swap_node(pos, {name="3dforniture:toilet", param2=node.param2})
					minetest.sound_play("3dforniture_dig_toilet", {
						pos=pos,
						max_hear_distance = 10,
						gain = 0.5,
					})
				end,
			})

			--Sink
			minetest.register_node("3dforniture:sink",
				{description = 'Sink',
				tiles = {
					"forniture_marble_top_sink.png", "forniture_marble.png",
					"forniture_marble_sb1.png", "forniture_marble_sb1.png",
					"forniture_marble_sb2.png", "forniture_marble_sb2.png",
				},
				inventory_image = "3dforniture_inv_sink.png",
				drawtype = "nodebox",
				sunlight_propagates = true,
				paramtype = 'light',
				paramtype2 = 'facedir',
				node_box = {
					type = "fixed",
					fixed = {
						{-0.15,0.35,0.2,0.15,0.4,0.5},
						{-0.25,0.4,0.4, 0.25,0.45,0.5},
						{-0.25,0.4,0.15, -0.15,0.45,0.4},
						{0.15,0.4,0.15, 0.25,0.45,0.4},
						{-0.15,0.4,0.15, 0.15,0.45,0.2},
						{-0.3,0.45,0.4, 0.3,0.5,0.5},
						{-0.3,0.45,0.1, -0.25,0.5,0.4},
						{0.25,0.45,0.1, 0.3,0.5,0.4},
						{-0.25,0.45,0.1, 0.25,0.5,0.15},
					},
				},
				selection_box = {
					type = "fixed",
					fixed = {-0.3,0.35,0.1, 0.3,0.5,0.5},
				},
				groups = {cracky=2,}
			})

			--Taps
			minetest.register_node("3dforniture:taps",
				{ description = 'Taps',
				tiles = {
					"forniture_metal.png", "forniture_metal.png",
					"forniture_metal_s1.png", "forniture_metal_s1.png",
					"forniture_metal_s2.png", "forniture_metal_s2.png",
				},
				inventory_image = "3dforniture_inv_taps.png",
				drawtype = "nodebox",
				sunlight_propagates = true,
				paramtype = 'light',
				paramtype2 = 'facedir',
				node_box = {
					type = "fixed",
					fixed = {
						--Base
						{-0.25,-0.45,0.49, 0.25,-0.3,0.5},
						{-0.05,-0.4,0.25, 0.05,-0.35,0.5},
						{-0.05,-0.425,0.25,0.05,-0.4,0.3},

						--taps 1
						{-0.2,-0.4,0.45, -0.15,-0.35,0.5},
						{-0.2,-0.45,0.4, -0.15,-0.3,0.45},
						{-0.25,-0.4,0.4, -0.1,-0.35,0.45},

						--taps 2 
						{0.15,-0.4,0.45, 0.2,-0.35,0.5},
						{0.15,-0.45,0.4, 0.2,-0.3,0.45},
						{0.1,-0.4,0.4, 0.25,-0.35,0.45},
					},
				},
				selection_box = {
					type = "fixed",
					fixed = {-0.25,-0.45,0.25, 0.25,-0.3,0.5},
				},
				groups = {cracky=2,}
			})

			--Shower Tray
			minetest.register_node("3dforniture:shower_tray",
				{ description = 'Shower Tray',
				tiles = {
					"forniture_marble_base_ducha_top.png",
					"forniture_marble_base_ducha_top.png",
					"forniture_marble_sb1.png",
					"forniture_marble_sb1.png",
					"forniture_marble_sb2.png",
					"forniture_marble_sb2.png",
				},
				inventory_image = "3dforniture_inv_shower_tray.png",
				drawtype = "nodebox",
				sunlight_propagates = true,
				paramtype = 'light',
				paramtype2 = 'facedir',
				legacy_facedir_simple = true,
				node_box = {
					type = "fixed",
					fixed = {
						{-0.5,-0.5,-0.5, 0.5,-0.45,0.5},
						{-0.5,-0.45,-0.5, 0.5,-0.4,-0.45},
						{-0.5,-0.45,0.45, 0.5,-0.4,0.5},
						{-0.5,-0.45,-0.45, -0.45,-0.4,0.45},
						{0.45,-0.45,-0.45, 0.5,-0.4,0.45},
					},
				},
				selection_box = {
					type = "fixed",
					fixed = {-0.5,-0.5,-0.5, 0.5,-0.4,0.5},
				},
				groups = {cracky=2,}
			})

			--Shower Head
			minetest.register_node("3dforniture:shower_head",
				{description = 'Shower Head',
				tiles = {
					"forniture_metal.png",
					"forniture_metal.png",
					"forniture_metal_s1.png",
					"forniture_metal_s1.png",
					"forniture_metal_s2.png",
					"forniture_metal_s2.png",
				},
				inventory_image = "3dforniture_inv_shower_head.png",
				drawtype = "nodebox",
				sunlight_propagates = true,
				paramtype = 'light',
				paramtype2 = 'facedir',
				node_box = {
					type = "fixed",
					fixed = {
						{-0.1,-0.5,0.1, 0.1,-0.4,0.3},
						{-0.05,-0.4,0.15, 0.05,-0.3,0.25},
						{-0.05,-0.35,0.25,0.05,-0.3,0.5},
						{-0.1,-0.4,0.49, 0.1,-0.25,0.5},
					},
				 },
				 selection_box = {
					type = "fixed",
					fixed = {-0.1,-0.5,0.1, 0.1,-0.25,0.5},
				},
				groups = {cracky=2,}
			})

	-- Medieval Forniture

		--Bars
		minetest.register_node("3dforniture:bars",
			{ description = 'Bars',
			tiles = {
				"forniture_black_metal.png",
				"forniture_black_metal.png",
				"forniture_black_metal_s1.png",
				"forniture_black_metal_s1.png",
				"forniture_black_metal_s2.png",
				"forniture_black_metal_s2.png",
			},
			drawtype = "nodebox",
			sunlight_propagates = true,
			paramtype = 'light',
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.5,-0.5,-0.1, -0.4,0.5,0.1},
					{-0.1,-0.5,-0.1, 0.1,0.5,0.1},
					{0.4,-0.5,-0.1, 0.5,0.5,0.1},
					{-0.5,-0.5,-0.05, 0.5,-0.45,0.05},
					{-0.5,0.45,-0.05, 0.5,0.5,0.05}
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {-0.5, -0.5, -0.1, 0.5, 0.5, 0.1},
			},
			groups = {cracky=1}
		})

		--L Binding Bars
		minetest.register_node("3dforniture:L_binding_bars",
			{ description ='Binding Bars',
			tiles = {
				"forniture_black_metal.png",
				"forniture_black_metal.png",
				"forniture_black_metal_s1.png",
				"forniture_black_metal_s1.png",
				"forniture_black_metal_s2.png",
				"forniture_black_metal_s2.png",
			},
			drawtype = "nodebox",
			sunlight_propagates = true,
			paramtype = 'light',
			paramtype2 ="facedir",
			node_box = {
				type = "fixed",
				fixed = {
					{-0.1,-0.5,-0.5,0.1,0.5,-0.4},
					{-0.15,-0.5,-0.15, 0.15,0.5,0.15},
					{0.4,-0.5,-0.1, 0.5,0.5,0.1},
					{0,-0.5,-0.05, 0.5,-0.45,0.05},
					{-0.05,-0.5,-0.5, 0.05,-0.45,0},
					{0,0.45,-0.05, 0.5,0.5,0.05},
					{-0.05,0.45,-0.5, 0.05,0.5,0},
				},
			},
			groups = {cracky=1,}
		})

		--Chains
		minetest.register_node("3dforniture:chains",
			{ description = 'Chains',
			tiles = {
				"forniture_black_metal.png",
				"forniture_black_metal.png",
				"forniture_black_metal_s1.png",
				"forniture_black_metal_s1.png",
				"forniture_black_metal_s2.png",
				"forniture_black_metal_s2.png",
			},
			inventory_image = "3dforniture_inv_chains.png",
			drawtype = "nodebox",
			sunlight_propagates = true,
			paramtype = 'light',
			paramtype2 = "facedir",
			node_box = {
				type = "fixed",
				fixed = {
					--chain a

					--supporting
					{-0.45,0.25,0.45, -0.2,0.5,0.5},
					{-0.35,0.4,0.35, -0.3,0.45,0.45},
					{-0.35,0.3,0.35, -0.3,0.35,0.45},
					{-0.35,0.35,0.3, -0.3,0.4,0.35},

					--link 1
					{-0.4,0.35,0.35, -0.25,0.4,0.4},
					{-0.4,0.15,0.35, -0.25,0.2,0.4},
					{-0.45,0.2,0.35, -0.4,0.35,0.4},
					{-0.25,0.2,0.35, -0.2,0.35,0.4},

					--link 2
					{-0.35,0.2,0.3, -0.3,0.25,0.45},
					{-0.35,0,0.3, -0.3,0.05,0.45},
					{-0.35,0.05,0.25, -0.3,0.2,0.3},
					{-0.35,0.05,0.45, -0.3,0.2,0.5},

					--link 3
					{-0.4,0.05,0.35, -0.25,0.1,0.4},
					{-0.4,-0.15,0.35, -0.25,-0.1,0.4},
					{-0.45,-0.1,0.35, -0.4,0.05,0.4},
					{-0.25,-0.1,0.35, -0.2,0.05,0.4},

					--link 4
					{-0.35,-0.1,0.3, -0.3,-0.05,0.45},
					{-0.35,-0.3,0.3, -0.3,-0.25,0.45},
					{-0.35,-0.25,0.25, -0.3,-0.1,0.3},
					{-0.35,-0.25,0.45, -0.3,-0.1,0.5},

					--link 5
					{-0.4,-0.25,0.35, -0.25,-0.2,0.4},
					{-0.4,-0.45,0.35, -0.25,-0.4,0.4},
					{-0.45,-0.4,0.35, -0.4,-0.25,0.4},
					{-0.25,-0.4,0.35, -0.2,-0.25,0.4},

				--chain b

					--supporting
					{0.2,0.25,0.45, 0.45,0.5,0.5},
					{0.3,0.4,0.35,0.35,0.45,0.45},
					{0.3,0.3,0.35, 0.35,0.35,0.45},
					{0.3,0.35,0.3, 0.35,0.4,0.35},

					--link 1
					{0.25,0.35,0.35, 0.4,0.4,0.4},
					{0.25,0.15,0.35, 0.4,0.2,0.4},
					{0.2,0.2,0.35, 0.25,0.35,0.4},
					{0.4,0.2,0.35, 0.45,0.35,0.4},

					--link 2
					{0.3,0.2,0.3, 0.35,0.25,0.45},
					{0.3,0,0.3, 0.35,0.05,0.45},
					{0.3,0.05,0.25, 0.35,0.2,0.3},
					{0.3,0.05,0.45, 0.35,0.2,0.5},

					--link 3
					{0.25,0.05,0.35, 0.4,0.1,0.4},
					{0.25,-0.15,0.35, 0.4,-0.1,0.4},
					{0.2,-0.1,0.35, 0.25,0.05,0.4},
					{0.4,-0.1,0.35, 0.45,0.05,0.4},

					--link 4
					{0.3,-0.1,0.3, 0.35,-0.05,0.45},
					{0.3,-0.3,0.3, 0.35,-0.25,0.45},
					{0.3,-0.25,0.25, 0.35,-0.1,0.3},
					{0.3,-0.25,0.45, 0.35,-0.1,0.5},

					---link 5
					{0.25,-0.25,0.35, 0.4,-0.2,0.4},
					{0.25,-0.45,0.35,0.4,-0.4,0.4},
					{0.2,-0.4,0.35, 0.25,-0.25,0.4},
					{0.4,-0.4,0.35, 0.45,-0.25,0.4},
				},
			},
			selection_box = {
				type = "fixed",
				fixed = {-1/2, -1/2, 1/4, 1/2, 1/2, 1/2}, },
				 groups = {cracky=1}
		})  

		--Torch Wall
		minetest.register_node("3dforniture:torch_wall",
			{ description = 'Torch Wall',
			drawtype = "nodebox",
			tiles = {
				"forniture_torch_wall_s.png",
				"forniture_torch_wall_i.png",
				{ name="forniture_torch_wall_anim.png",
				animation={
					type="vertical_frames",
					aspect_w=40,
					aspect_h=40,
					length=1.0
					}
				}
			},
			inventory_image = "3dforniture_inv_torch_wall.png",
			 paramtype = 'light',
			 paramtype2 = "facedir",
			 node_box = {
				type = "fixed",
				fixed = {

					--torch
					{-0.05,-0.45,0.45, 0.05,-0.35,0.5},
					{-0.05,-0.35,0.4, 0.05,-0.25,0.5},
					{-0.05,-0.25,0.35, 0.05,-0.15,0.45},
					{-0.05,-0.15,0.3, 0.05,-0.05,0.4},
					{-0.05,-0.05,0.25, 0.05,0,0.35},

					--fire
					{-0.1,0,0.2, 0.1,0.05,0.4},
					{-0.15,0.05,0.15, 0.15,0.15,0.45},
					{-0.1,0.15,0.2, 0.1,0.25,0.4},
					{-0.05,0.25,0.25, 0.05,0.35,0.35},
				},
			},
			sunlight_propagates = true,
			walkable = false,
			light_source = 18,
			selection_box = {
				type = "fixed",
				fixed = {-0.15, -0.45, 0.15, 0.15,0.35, 0.5},
			},
			groups = {cracky=2}
		})
