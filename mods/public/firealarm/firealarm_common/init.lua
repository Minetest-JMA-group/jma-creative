firealarm = {}

firealarm.devices = {
	panel = {},
	signaling = {},
	notification = {},
	annunciator = {},
}

-- Set to true when the devices file fails to load or contains invalid data.
-- While disabled the mod saves nothing, every device behaves like a static,
-- non-functional block and the corrupt file is left untouched for inspection
-- or recovery.
firealarm.disabled = false

if not core.safe_file_write then
	error("firealarm_common requires Luanti 5.8 or newer (core.safe_file_write)")
end

function firealarm.loadNode(pos)
	if firealarm.disabled then return end
	minetest.forceload_block(pos,true)
end

function firealarm.loadDevLists()
	local path = minetest.get_worldpath().."/firealarm_devices"
	local file = io.open(path,"r")
	if not file then
		minetest.log("warning","Unable to open fire alarm devices table for reading. "..
		                     "This is normal on the first start.")
		firealarm.saveDevLists()
		return
	end
	local serdata = file:read("*a")
	file:close()
	local data = minetest.deserialize(serdata)
	if type(data) == "table" then
		if not data.annunciator then data.annunciator = {} end
		if type(data.panel) == "table" and type(data.signaling) == "table" and
		   type(data.notification) == "table" then
			firealarm.devices = data
		else
			firealarm.disable(path)
		end
	else
		firealarm.disable(path)
	end
end

-- Called when the devices table is corrupted or has an unexpected shape.
-- The mod then refuses to do anything (see the guards in the functions below)
-- instead of crashing the server or silently overwriting the corrupt file.
function firealarm.disable(path)
	firealarm.disabled = true
	minetest.log("error","Fire alarm devices table is corrupted or contains invalid data ("..path.."). "..
		"The fire alarm mod is disabled: devices are non-functional, nothing is saved and the file "..
		"is left in place for inspection. Restore or delete the file and restart the server to "..
		"re-enable the mod.")
end

function firealarm.saveDevLists()
	if firealarm.disabled then return end
	local path = minetest.get_worldpath().."/firealarm_devices"
	local serdata = minetest.serialize(firealarm.devices)
	if not serdata then
		minetest.log("error","Unable to serialize the fire alarm devices table; not saving")
		return
	end
	if not core.safe_file_write(path, serdata) then
		minetest.log("error","Unable to write the fire alarm devices table to "..path)
	end
end

function firealarm.getDevInfo(devType,pos)
	if devType ~= "panel" and devType ~= "signaling" and devType ~= "notification" and devType ~= "annunciator" then
		error("Invalid device type specified")
	end
	if firealarm.disabled then return nil end
	local hash = minetest.hash_node_position(pos)
	return firealarm.devices[devType][hash]
end

function firealarm.setDevInfo(devType,pos,info)
	if devType ~= "panel" and devType ~= "signaling" and devType ~= "notification" and devType ~= "annunciator" then
		error("Invalid device type specified")
	end
	if firealarm.disabled then return end
	local hash = minetest.hash_node_position(pos)
	firealarm.devices[devType][hash] = info
	firealarm.saveDevLists()
end

firealarm:loadDevLists()

sprinkler = {}

sprinkler.devices = {
	panel = {},
	signaling = {},
	notification = {},
	annunciator = {},
}

sprinkler.disabled = false

function sprinkler.loadNode(pos)
	if sprinkler.disabled then return end
	minetest.forceload_block(pos,true)
end

function sprinkler.loadDevLists()
	local path = minetest.get_worldpath().."/sprinkler_devices"
	local file = io.open(path,"r")
	if not file then
		minetest.log("warning","Unable to open sprinkler devices table for reading. "..
		                     "This is normal on the first start.")
		sprinkler.saveDevLists()
		return
	end
	local serdata = file:read("*a")
	file:close()
	local data = minetest.deserialize(serdata)
	if type(data) == "table" then
		if not data.annunciator then data.annunciator = {} end
		if type(data.panel) == "table" and type(data.signaling) == "table" and
		   type(data.notification) == "table" then
			sprinkler.devices = data
		else
			sprinkler.disable(path)
		end
	else
		sprinkler.disable(path)
	end
end

function sprinkler.disable(path)
	sprinkler.disabled = true
	minetest.log("error","Sprinkler devices table is corrupted or contains invalid data ("..path.."). "..
		"The sprinkler mod is disabled: devices are non-functional, nothing is saved and the file "..
		"is left in place for inspection. Restore or delete the file and restart the server to "..
		"re-enable the mod.")
end

function sprinkler.saveDevLists()
	if sprinkler.disabled then return end
	local path = minetest.get_worldpath().."/sprinkler_devices"
	local serdata = minetest.serialize(sprinkler.devices)
	if not serdata then
		minetest.log("error","Unable to serialize the sprinkler devices table; not saving")
		return
	end
	if not core.safe_file_write(path, serdata) then
		minetest.log("error","Unable to write the sprinkler devices table to "..path)
	end
end

function sprinkler.getDevInfo(devType,pos)
	if devType ~= "panel" and devType ~= "signaling" and devType ~= "notification" and devType ~= "annunciator" then
		error("Invalid device type specified")
	end
	if sprinkler.disabled then return nil end
	local hash = minetest.hash_node_position(pos)
	return sprinkler.devices[devType][hash]
end

function sprinkler.setDevInfo(devType,pos,info)
	if devType ~= "panel" and devType ~= "signaling" and devType ~= "notification" and devType ~= "annunciator" then
		error("Invalid device type specified")
	end
	if sprinkler.disabled then return end
	local hash = minetest.hash_node_position(pos)
	sprinkler.devices[devType][hash] = info
	sprinkler.saveDevLists()
end

sprinkler:loadDevLists()

-- ---------------------------------------------------------------------------
-- Deferred reconciliation with the database.
--
-- Devices that exist in the world but are missing from the database (or whose
-- panel association is broken) are handled as their mapblock becomes active,
-- instead of scanning the whole map at once. The cleanup ABM only runs while
-- the respective database loaded cleanly - with a corrupt (empty) table every
-- node would look orphaned and would be wrongly decommissioned or removed.
--
-- The behavior is controlled by the "firealarm.orphan_policy" setting:
--   "decommission" (default) - keep the node, show a notice on panels
--   "remove"                 - remove the node
--   "off"                    - only log each finding once
-- ---------------------------------------------------------------------------

-- Shows a "decommissioned" notice on a node whose configuration is missing.
-- Applied once per node; harmless on devices without a formspec.
function firealarm.markDecommissioned(pos)
	local meta = minetest.get_meta(pos)
	if meta:get_int("firealarm_decommissioned") == 1 then return end
	meta:set_int("firealarm_decommissioned", 1)
	meta:set_string("formspec",
		"size[7,2.5]"..
		"label[0.3,0.3;This device is decommissioned.]"..
		"label[0.3,1.0;Its configuration data was lost from the database.]"..
		"label[0.3,1.5;Dig it up to remove it.]")
end

sprinkler.markDecommissioned = firealarm.markDecommissioned

local function orphanPolicy()
	return minetest.settings:get("firealarm.orphan_policy") or "decommission"
end

local function isFirealarmNodeName(name)
	return name:sub(1, 10) == "firealarm:"
end

-- Sprinkler nodes are named firealarm:sprinkler_*, everything else belongs
-- to the fire alarm namespace.
local function nodeNamespace(nodeName)
	if nodeName:find("sprinkler", 1, true) then
		return sprinkler
	end
	return firealarm
end

local function findDevice(ns, hash)
	for _, devType in ipairs({"panel", "signaling", "notification", "annunciator"}) do
		local info = ns.devices[devType][hash]
		if info then
			return devType, info
		end
	end
	return nil
end

local function panelListsDevice(panelInfo, devType, hash)
	local listName = ({
		signaling = "associatedSignalingDevices",
		notification = "associatedNotificationDevices",
		annunciator = "associatedAnnunciators",
	})[devType]
	local list = panelInfo[listName]
	return list and list[hash] ~= nil
end

-- Handles a device that is missing from the database or has a broken panel
-- association. Logs the finding once per node, then applies the policy.
-- Returns true when the node was removed.
local function applyOrphanPolicy(pos, node, reason)
	local meta = minetest.get_meta(pos)
	if meta:get_int("firealarm_decommissioned") == 1 then return false end
	minetest.log("warning","Fire alarm: "..node.name.." at "..minetest.pos_to_string(pos).." "..reason)
	local policy = orphanPolicy()
	if policy == "remove" then
		meta:set_int("firealarm_decommissioned", 1)
		minetest.set_node(pos, {name = "air"})
		return true
	elseif policy == "decommission" then
		-- markDecommissioned sets the flag itself; it must run before the
		-- flag is set or the notice formspec would never be written.
		firealarm.markDecommissioned(pos)
	else
		-- "off": only log, but remember the finding so it is logged once.
		meta:set_int("firealarm_decommissioned", 1)
	end
	return false
end

minetest.register_on_mods_loaded(function()
	if firealarm.disabled and sprinkler.disabled then
		return
	end
	local nodenames = {}
	for name in pairs(minetest.registered_nodes) do
		if isFirealarmNodeName(name) then
			table.insert(nodenames, name)
		end
	end
	if #nodenames == 0 then
		return
	end
	minetest.register_abm({
		label = "Reconcile fire alarm devices with the database",
		nodenames = nodenames,
		interval = 8,
		chance = 1,
		action = function(pos, node)
			if firealarm.disabled and sprinkler.disabled then
				return
			end
			local ns = nodeNamespace(node.name)
			if ns.disabled then
				return
			end
			local hash = minetest.hash_node_position(pos)
			local devType, devInfo = findDevice(ns, hash)
			if not devInfo then
				applyOrphanPolicy(pos, node, "is missing from the database")
				return
			end
			if devType ~= "panel" and devInfo.associated then
				local panelInfo = ns.devices.panel[devInfo.associated]
				if not panelInfo or not panelListsDevice(panelInfo, devType, hash) then
					if applyOrphanPolicy(pos, node, "has a broken panel association") then
						-- The node was removed; drop its database entry as well.
						ns.setDevInfo(devType, pos, nil)
					elseif orphanPolicy() ~= "off" then
						-- Reset the device so it stops acting on stale state
						-- (e.g. a horn/strobe left stuck on by a lost alarm).
						devInfo.associated = nil
						if devType == "notification" then
							devInfo.hornActive = false
							devInfo.strobeActive = false
						end
						ns.setDevInfo(devType, pos, devInfo)
					end
				end
			end
		end,
	})
end)
