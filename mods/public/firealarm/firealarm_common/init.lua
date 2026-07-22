firealarm = {}

firealarm.devices = {
	panel = {},
	signaling = {},
	notification = {},
	annunciator = {},
}

function firealarm.loadNode(pos)
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
		firealarm.devices = data
	else
		error("Fire alarm devices table is corrupted or contains invalid data")
	end
end

function firealarm.saveDevLists()
	local path = minetest.get_worldpath().."/firealarm_devices"
	local file = io.open(path,"w")
	if not file then
		minetest.log("error","Unable to open fire alarm devices table for writing")
		return
	end
	local serdata = minetest.serialize(firealarm.devices)
	file:write(serdata)
	file:close()
end

function firealarm.getDevInfo(devType,pos)
	if devType ~= "panel" and devType ~= "signaling" and devType ~= "notification" and devType ~= "annunciator" then
		error("Invalid device type specified")
	end
	local hash = minetest.hash_node_position(pos)
	return firealarm.devices[devType][hash]
end

function firealarm.setDevInfo(devType,pos,info)
	if devType ~= "panel" and devType ~= "signaling" and devType ~= "notification" and devType ~= "annunciator" then
		error("Invalid device type specified")
	end
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

function sprinkler.loadNode(pos)
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
		sprinkler.devices = data
	else
		error("Sprinkler devices table is corrupted or contains invalid data")
	end
end

function sprinkler.saveDevLists()
	local path = minetest.get_worldpath().."/sprinkler_devices"
	local file = io.open(path,"w")
	if not file then
		minetest.log("error","Unable to open sprinkler devices table for writing")
		return
	end
	local serdata = minetest.serialize(sprinkler.devices)
	file:write(serdata)
	file:close()
end

function sprinkler.getDevInfo(devType,pos)
	if devType ~= "panel" and devType ~= "signaling" and devType ~= "notification" and devType ~= "annunciator" then
		error("Invalid device type specified")
	end
	local hash = minetest.hash_node_position(pos)
	return sprinkler.devices[devType][hash]
end

function sprinkler.setDevInfo(devType,pos,info)
	if devType ~= "panel" and devType ~= "signaling" and devType ~= "notification" and devType ~= "annunciator" then
		error("Invalid device type specified")
	end
	local hash = minetest.hash_node_position(pos)
	sprinkler.devices[devType][hash] = info
	sprinkler.saveDevLists()
end

sprinkler:loadDevLists()
