local MoonwaveExtractor = require("./moonwave-extractor")

export type DocumentationCategory = MoonwaveExtractor.DocumentationCategory
export type MoonwaveClass = MoonwaveExtractor.MoonwaveClass
export type MoonwaveDocumentation = MoonwaveExtractor.MoonwaveDocumentation
export type MoonwaveFunction = MoonwaveExtractor.MoonwaveFunction
export type MoonwaveFunctionParameter = MoonwaveExtractor.MoonwaveFunctionParameter
export type MoonwaveInterface = MoonwaveExtractor.MoonwaveInterface
export type MoonwaveLuaType = MoonwaveExtractor.MoonwaveLuaType
export type MoonwaveProperty = MoonwaveExtractor.MoonwaveProperty
export type MoonwaveSource = MoonwaveExtractor.MoonwaveSource

local NEW_LINE = "\n"
local LINE_BREAK = "\n\n"

local function heading(level: number, ...: string)
	return "\n\n" .. ("#"):rep(level) .. " " .. table.concat({ ... }, " ") .. "\n\n"
end

local function writeMoonwaveFunction(
	fn: MoonwaveExtractor.MoonwaveFunction,
	baseHeadingLevel: number,
	class: MoonwaveExtractor.MoonwaveClass?
)
	local contents = "```luau"
	contents ..= NEW_LINE
	contents ..= "function "
	if class then
		contents ..= class.name
		contents ..= "."
	end
	contents ..= fn.name
	contents ..= "("

	local numParams = #fn.params
	if numParams == 1 then
		local param = fn.params[1]
		contents ..= param.name
		contents ..= ": "
		contents ..= param.lua_type
	elseif numParams > 1 then
		local params = {}
		for _, param in fn.params do
			table.insert(params, NEW_LINE .. "\t" .. param.name .. ": " .. param.lua_type)
		end
		contents ..= table.concat(params, ",")
	end

	contents ..= "): "

	local numReturns = #fn.returns
	if numReturns == 1 then
		contents ..= fn.returns[1].lua_type
	elseif numReturns > 1 then
		local returns = {}
		for _, r in fn.returns do
			table.insert(returns, r.lua_type)
		end
		contents ..= "("
		contents ..= table.concat(returns, ", ")
		contents ..= ")"
	else
		contents ..= "()"
	end

	contents ..= NEW_LINE
	contents ..= "```"
	contents ..= LINE_BREAK
	contents ..= fn.desc
	contents ..= LINE_BREAK

	if numParams > 0 then
		contents ..= heading(baseHeadingLevel + 1)
		for _, p in fn.params do
			contents ..= LINE_BREAK
			contents ..= heading(baseHeadingLevel + 2)
			contents ..= p.name
			contents ..= " <small>`: "
			contents ..= p.lua_type:gsub("\n", "")
			contents ..= "`</small>"
			contents ..= LINE_BREAK
			contents ..= p.desc
		end
	end

	if numReturns > 0 then
		contents ..= heading(baseHeadingLevel + 1)
		for _, r in fn.returns do
			contents ..= LINE_BREAK
			contents ..= heading(baseHeadingLevel + 2)
			contents ..= " `"
			contents ..= r.lua_type:gsub("\n", "")
			contents ..= "`"
			contents ..= LINE_BREAK
			contents ..= r.desc
			contents ..= "`"
		end
	end
	return contents
end

local function writeMoonwaveProperty(
	property: MoonwaveExtractor.MoonwaveProperty,
	class: MoonwaveExtractor.MoonwaveClass?
)
	local contents = "```luau"
	contents ..= NEW_LINE
	if class then
		contents ..= class.name
		contents ..= "."
	end
	contents ..= property.name
	contents ..= ": "
	contents ..= property.lua_type
	contents ..= "\n\n"
	contents ..= "```"
	contents ..= LINE_BREAK
	contents ..= property.desc
	contents ..= LINE_BREAK
	return contents
end

return {
	NEW_LINE = NEW_LINE,
	LINE_BREAK = LINE_BREAK,
	extract = MoonwaveExtractor.extract,
	heading = heading,
	writeMoonwaveFunction = writeMoonwaveFunction,
	writeMoonwaveProperty = writeMoonwaveProperty,
}
