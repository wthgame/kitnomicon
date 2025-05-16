local remodel = require("./remodel")
local stdio = require("@lune/stdio")
local roblox = require("@lune/roblox")
local process = require("@lune/process")
local fs = require("@lune/fs")
local fsUtils = require("./fs-utils")

-- NOTE: The kit place is private as of now, but we should make it public, or
-- at least publish a mirror game of the development kit, so others can build
-- the documentation.
local KIT_DEVELOPMENT_PLACE_ID = 113552277431105
local KIT_FILE = "kit.rbxl"
local MIRROR_DIR = "mirror"

local Enum = (roblox :: any).Enum :: typeof(Enum)

local function downloadKitFile()
	if remodel.isFile(KIT_FILE) then
		local shouldRedownload = stdio.prompt("confirm", "Do you want to redownload the kit from Roblox?")
		if not shouldRedownload then
			remodel.readPlaceFile(KIT_FILE)
			return
		end
	end

	print("Downloading kit...")
	remodel.writePlaceFile(KIT_FILE, remodel.readPlaceAsset(KIT_DEVELOPMENT_PLACE_ID))
end

local function readKitFile(): roblox.DataModel
	downloadKitFile()
	return remodel.readPlaceFile(KIT_FILE)
end

local writeKitModules
local blacklist = { "node_modules" }
do
	local function writeKitModulesForInstance(instance: roblox.Instance, parent: string)
		for _, blacklisted in blacklist do
			if instance:GetFullName():find(blacklisted) ~= nil then
				return
			end
		end
		-- HACK: spam init.luau files to not worry about shitty rojo
		-- compatibility
		local path = `{parent}{fsUtils.delimiter}{instance.Name}`
		if not fs.isDir(path) then
			fs.writeDir(path)
		end
		print(path)
		if instance:IsA("LuaSourceContainer") then
			local extension = if instance:IsA("LocalScript")
				then ".client.luau"
				elseif instance:IsA("Script") then if (instance :: any).RunContext == Enum.RunContext.Client
					then ".client.luau"
					else ".server.luau"
				else ".luau"
			local modulePath = `{path}{fsUtils.delimiter}init{extension}`
			fs.writeFile(modulePath, (instance :: any).Source)
		end
		local children = instance:GetChildren()
		if #children > 0 then
			for _, child in children do
				writeKitModulesForInstance(child, path)
			end
		end
	end

	function writeKitModules()
		if not fs.isDir(MIRROR_DIR) then
			fs.writeDir(MIRROR_DIR)
		end
		print("Writing kit modules at", MIRROR_DIR)
		local game = readKitFile()
		local writeModulesFor = { game:GetService("ReplicatedStorage"), game:GetService("ServerScriptService") }
		for _, writeFor in writeModulesFor do
			writeKitModulesForInstance(writeFor, MIRROR_DIR)
		end
		print("Finished writing kit modules at", MIRROR_DIR)
	end
end

return {
	KIT_DEVELOPMENT_PLACE_ID = KIT_DEVELOPMENT_PLACE_ID,
	KIT_FILE = KIT_FILE,
	MIRROR_DIR = MIRROR_DIR,
	downloadKitFile = downloadKitFile,
	readKitFile = readKitFile,
	writeKitModules = writeKitModules,
}
