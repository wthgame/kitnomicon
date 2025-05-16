-- https://github.com/prvdmwrong/prvdmwrong/blob/b4fd0eb527d09824692b67c7838f8c51ed7a9e9a/lune/docs/moonwave.luau

local process = require("@lune/process")
local serde = require("@lune/serde")
local execute = require("./execute")

export type DocumentationCategory = {
	content: string,
	kinds: {
		[string]: {
			[string]: string,
		},
	},
}

export type MoonwaveInterface = {
	desc: string,
	name: string,
	fields: { MoonwaveLuaType & { name: string } }?,
	source: MoonwaveSource,
}

export type MoonwaveLuaType = {
	desc: string,
	lua_type: string,
}

export type MoonwaveFunctionParameter = MoonwaveLuaType & {
	name: string,
}

export type MoonwaveSource = {
	line: number,
	path: string,
}

export type MoonwaveFunction = {
	name: string,
	desc: string,
	function_type: "static",
	since: string?,
	params: { MoonwaveFunctionParameter },
	returns: { MoonwaveLuaType },
	source: MoonwaveSource,
}

export type MoonwaveProperty = {
	name: string,
	desc: string,
	lua_type: string,
	tags: { string }?,
	source: MoonwaveSource,
}

export type MoonwaveClass = {
	name: string,
	desc: string,
	since: string?,
	source: MoonwaveSource,
	functions: { MoonwaveFunction },
	types: { MoonwaveInterface },
	properties: { MoonwaveProperty },
	tags: { string }?,
}

export type MoonwaveDocumentation = { MoonwaveClass }

local hasMoonwave = false
local Moonwave = {}

local function assertMoonwave()
	if hasMoonwave then
		return
	end
	local testMoonwave = execute({ "moonwave-extractor", "-V" })
	if not testMoonwave.ok then
		print("Missing `moonwave-extractor` tool (download it via Cargo: `cargo install moonwave`)")
		process.exit(1)
	end
	hasMoonwave = true
end

function Moonwave.extract(fromFile: string): MoonwaveDocumentation
	assertMoonwave()
	local result = execute({ "moonwave-extractor", "extract", fromFile })

	if not result.ok then
		print("Moonwave threw an error while extracting", fromFile)
		print(result.stdout)
		print(result.stderr)
		process.exit(1)
	end

	return serde.decode("json", result.stdout)
end

table.freeze(Moonwave)
return Moonwave
