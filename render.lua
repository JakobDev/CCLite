local COLOUR_RGB = {
	WHITE = {240, 240, 240},
	ORANGE = {242, 178, 51},
	MAGENTA = {229, 127, 216},
	LIGHT_BLUE = {153, 178, 242},
	YELLOW = {222, 222, 108},
    --YELLOW = {0.87058824, 0.87058824, 0.42352942},
	LIME = {127, 204, 25},
	PINK = {242, 178, 204},
	GRAY = {76, 76, 76},
	LIGHT_GRAY = {153, 153, 153},
	CYAN = {76, 153, 178},
	PURPLE = {178, 102, 229},
	BLUE = {51, 102, 204},
	BROWN = {127, 102, 76},
	GREEN = {87, 166, 78},
	RED = {204, 76, 76},
	BLACK = {25, 25, 25},
}

local COLOUR_CODE = {
	[1] = COLOUR_RGB.WHITE,
	[2] = COLOUR_RGB.ORANGE,
	[4] =  COLOUR_RGB.MAGENTA,
	[8] = COLOUR_RGB.LIGHT_BLUE,
	[16] = COLOUR_RGB.YELLOW,
	[32] = COLOUR_RGB.LIME,
	[64] = COLOUR_RGB.PINK,
	[128] = COLOUR_RGB.GRAY,
	[256] = COLOUR_RGB.LIGHT_GRAY,
	[512] = COLOUR_RGB.CYAN,
	[1024] = COLOUR_RGB.PURPLE,
	[2048] = COLOUR_RGB.BLUE,
	[4096] = COLOUR_RGB.BROWN,
	[8192] = COLOUR_RGB.GREEN,
	[16384] = COLOUR_RGB.RED,
	[32768] = COLOUR_RGB.BLACK,
}

Screen = {
	sWidth = (_conf.terminal_width * 6 * _conf.terminal_guiScale) + (_conf.terminal_guiScale * 2),
	sHeight = (_conf.terminal_height * 9 * _conf.terminal_guiScale) + (_conf.terminal_guiScale * 2),
	textB = {},
	backgroundColourB = {},
	textColourB = {},
	font = nil,
	pixelWidth = _conf.terminal_guiScale * 6,
	pixelHeight = _conf.terminal_guiScale * 9,
	showCursor = false,
	lastCursor = nil,
	dirty = true,
	tOffset = {},
	messages = {},
	setup = false,
}
for y = 1, _conf.terminal_height do
	Screen.textB[y] = {}
	Screen.backgroundColourB[y] = {}
	Screen.textColourB[y] = {}
	for x = 1, _conf.terminal_width do
		Screen.textB[y][x] = " "
		Screen.backgroundColourB[y][x] = 32768
		Screen.textColourB[y][x] = 1
	end
end

Screen.COLOUR_CODE = {
	[1] = COLOUR_RGB.WHITE,
	[2] = COLOUR_RGB.ORANGE,
	[4] =  COLOUR_RGB.MAGENTA,
	[8] = COLOUR_RGB.LIGHT_BLUE,
	[16] = COLOUR_RGB.YELLOW,
	[32] = COLOUR_RGB.LIME,
	[64] = COLOUR_RGB.PINK,
	[128] = COLOUR_RGB.GRAY,
	[256] = COLOUR_RGB.LIGHT_GRAY,
	[512] = COLOUR_RGB.CYAN,
	[1024] = COLOUR_RGB.PURPLE,
	[2048] = COLOUR_RGB.BLUE,
	[4096] = COLOUR_RGB.BROWN,
	[8192] = COLOUR_RGB.GREEN,
	[16384] = COLOUR_RGB.RED,
	[32768] = COLOUR_RGB.BLACK,
}

local glyphs = ""
for i = 32,126 do
	glyphs = glyphs .. string.char(i)
end
Screen.font = love.graphics.newImageFont("res/minecraft.png",glyphs)
Screen.font:setFilter("nearest","nearest")
love.graphics.setFont(Screen.font)
love.graphics.setLineWidth(_conf.terminal_guiScale)

for i = 32,126 do Screen.tOffset[string.char(i)] = math.ceil(3 - Screen.font:getWidth(string.char(i)) / 2) * _conf.terminal_guiScale end

local msgTime = love.timer.getTime() + 5
for i = 1,10 do
	Screen.messages[i] = {"",msgTime,false}
end

local COLOUR_FULL_WHITE = {255,255,255}
local COLOUR_FULL_BLACK = {0,0,0}
local COLOUR_HALF_BLACK = {0,0,0,72}
local COLOUR_HALF_WHITE = {255,255,255,127}

-- Local functions are faster than global
local lsetCol = love.graphics.setColor
local ldrawRect = love.graphics.rectangle
local lprint = love.graphics.print
local tOffset = Screen.tOffset
local decWidth = _conf.terminal_width - 1
local decHeight = _conf.terminal_height - 1

local lastColor = COLOUR_FULL_WHITE
local function setColor(c)
	if lastColor ~= c then
		lastColor = c
		lsetCol(c)
	end
end

if _conf.mobileMode then
	controlPad = {}
end

local messages = {}

function Screen:message(message)
	for i = 1,9 do
		self.messages[i] = self.messages[i+1]
	end
	self.messages[10] = {message,love.timer.getTime(),true}
	self.dirty = true
end

local function drawMessage(message,x,y)
	setColor(COLOUR_HALF_BLACK)
	ldrawRect("fill", x, y - _conf.terminal_guiScale, Screen.font:getWidth(message) * _conf.terminal_guiScale, Screen.pixelHeight)
	setColor(COLOUR_FULL_WHITE)
	lprint(message, x, y, 0, _conf.terminal_guiScale, _conf.terminal_guiScale)
end

local hidden = {
	["\0"]=true,
	["\9"]=true,
	["\r"]=true,
	["\n"]=true,
	[" "]=true,
}
function Screen:draw()
	-- Render terminal
	if not Computer.running then
		setColor(COLOUR_FULL_BLACK)
		ldrawRect("fill", 0, 0, self.sWidth, self.sHeight)
	else
		-- Render background color
		setColor(self.COLOUR_CODE[self.backgroundColourB[1][1]])
		for y = 0, decHeight do
			local length, last, lastx = 0
			local ypos = y * self.pixelHeight + (y == 0 and 0 or _conf.terminal_guiScale)
			local ylength = self.pixelHeight + ((y == 0 or y == decHeight) and _conf.terminal_guiScale or 0)
			for x = 0, decWidth do
				if self.backgroundColourB[y + 1][x + 1] ~= last then
					if last then
						ldrawRect("fill", lastx * self.pixelWidth + (lastx == 0 and 0 or _conf.terminal_guiScale), ypos, self.pixelWidth * length + (lastx == 0 and _conf.terminal_guiScale or 0), ylength)
					end
					last = self.backgroundColourB[y + 1][x + 1]
					lastx = x
					length = 1
					setColor(self.COLOUR_CODE[last]) -- TODO COLOUR_CODE lookup might be too slow?
				else
					length = length + 1
				end
			end
			ldrawRect("fill", lastx * self.pixelWidth + (lastx == 0 and 0 or _conf.terminal_guiScale), ypos, self.pixelWidth * length + _conf.terminal_guiScale * (lastx == 0 and 2 or 1), ylength)
		end

		-- Render text
		for y = 0, decHeight do
			local self_textB = self.textB[y + 1]
			local self_textColourB = self.textColourB[y + 1]
			for x = 0, decWidth do
				local text = self_textB[x + 1]
				if not hidden[text] then
					local sByte = string.byte(text)
					if sByte < 32 or sByte > 126 then
						text = "?"
					end
					setColor(self.COLOUR_CODE[self_textColourB[x + 1]])
					lprint(text, x * self.pixelWidth + tOffset[text] + _conf.terminal_guiScale, y * self.pixelHeight + _conf.terminal_guiScale, 0, _conf.terminal_guiScale, _conf.terminal_guiScale)
				end
			end
		end

		-- Render cursor
		if Computer.state.blink and self.showCursor then
			setColor(COLOUR_CODE[Computer.state.fg])
			lprint("_", (Computer.state.cursorX - 1) * self.pixelWidth + tOffset["_"] + _conf.terminal_guiScale, (Computer.state.cursorY - 1) * self.pixelHeight + _conf.terminal_guiScale, 0, _conf.terminal_guiScale, _conf.terminal_guiScale)
		end
	end

	-- Render emulator elements
	for i = 1,10 do
		if self.messages[i][3] then
			drawMessage(self.messages[i][1],_conf.terminal_guiScale, self.sHeight - ((self.pixelHeight + _conf.terminal_guiScale) * (11 - i)) + _conf.terminal_guiScale)
		end
	end

	if _conf.cclite_showFPS then
		drawMessage("FPS: " .. Computer.FPS, self.sWidth - (49 * _conf.terminal_guiScale), _conf.terminal_guiScale * 2)
	end
	if _conf.mobileMode then
		local radius = 20 * _conf.terminal_guiScale
		local scale6 = 6 * _conf.terminal_guiScale
		local x, y = radius + scale6, love.window.getHeight() - radius - scale6
		controlPad["x"] = x
		controlPad["y"] = y
		controlPad["r"] = radius
		setColor(COLOUR_HALF_WHITE)
		love.graphics.circle("fill", x, y, radius, 100)
		setColor(COLOUR_FULL_BLACK)
		love.graphics.circle("line", x, y, radius, 100)
		love.graphics.circle("line", x, y, radius/2.5, 100)
		local radiusOut = radius*7/10
		local radiusIn = radius*3/10
		love.graphics.line(x - radiusOut, y + radiusOut, x - radiusIn, y + radiusIn)
		love.graphics.line(x - radiusOut, y - radiusOut, x - radiusIn, y - radiusIn)
		love.graphics.line(x + radiusOut, y - radiusOut, x + radiusIn, y - radiusIn)
		love.graphics.line(x + radiusOut, y + radiusOut, x + radiusIn, y + radiusIn)
	end
end
