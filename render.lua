--utf8 = require("utf8")

COLOUR_RGB = {
	WHITE = {240/255, 240/255, 240/255},
	ORANGE = {242/255, 178/255, 51/255},
	MAGENTA = {229/255, 127/255, 216/255},
	LIGHT_BLUE = {153/255, 178/255, 242/255},
	YELLOW = {222/255, 222/255, 108/255},
	LIME = {127/255, 204/255, 25/255},
	PINK = {242/255, 178/255, 204/255},
	GRAY = {76/255, 76/255, 76/255},
	LIGHT_GRAY = {153/255, 153/255, 153/255},
	CYAN = {76/255, 153/255, 178/255},
	PURPLE = {178/255, 102/255, 229/255},
	BLUE = {51/255, 102/255, 204/255},
	BROWN = {127/255, 102/255, 76/255},
	GREEN = {87/255, 166/255, 78/255},
	RED = {204/255, 76/255, 76/255},
	BLACK = {25/255, 25/255, 25/255},
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
for i = 0,255 do
    --glyphs = glyphs .. string.char(i)
    glyphs = glyphs .. utf8.char(i)
end
--local glyphs = "\1\2\3\4\5\6\7\8\9\10\11\12\13\14\15\16\17\18\19\20\21\22\23\24\25\26\27\28\29\30\31\32\33\34\35\36\37\38\39\40\41\42\43\44\45\46\47\48\49\50\51\52\53\54\55\56\57\58\59\60\61\62\63\64\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92\93\94\95\96\97\98\99\100\101\102\103\104\105\106\107\108\109\110\111\112\113\114\115\116\117\118\119\120\121\122\123\124\125\126\127\128\129\130\131\132\133\134\135\136\137\138\139\140\141\142\143\144\145\146\147\148\149\150\151\152\153\154\155\156\157\158\159\160\161\162\163\164\165\166\167\168\169\170\171\172\173\174\175\176\177\178\179\180\181\182\183\184\185\186\187\188\189\190\191\192\193\194\195\196\197\198\199\200\201\202\203\204\205\206\207\208\209\210\211\212\213\214\215\216\217\218\219\220\221\222\223\224\225\226\227\228\229\230\231\232\233\234\235\236\237\238\239\240\241\242\243\244\245\246\247\248\249\250\251\252\253\254\255"
Screen.font = love.graphics.newImageFont("res/font.png",glyphs)
Screen.font:setFilter("nearest","nearest")
love.graphics.setFont(Screen.font)
love.graphics.setLineWidth(_conf.terminal_guiScale)

for i = 0,255 do Screen.tOffset[i--[[utf8.char(i)]]] = math.ceil(3 - Screen.font:getWidth(utf8.char(i)) / 2) * _conf.terminal_guiScale end
cou = 0
for k,v in pairs(Screen.tOffset) do
    cou = cou + 1
end
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
decWidth = _conf.terminal_width - 1
decHeight = _conf.terminal_height - 1

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
	--if not Computer.running then
    if Computer.reboot == true then
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
					if sByte > 255 then
						text = "?"
					end
					setColor(self.COLOUR_CODE[self_textColourB[x + 1]])
					lprint(utf8.char(text), x * self.pixelWidth + tOffset[text] + _conf.terminal_guiScale, y * self.pixelHeight + _conf.terminal_guiScale, 0, _conf.terminal_guiScale, _conf.terminal_guiScale)
				end
			end
		end

		-- Render cursor
		if Computer.state.blink and self.showCursor then
			setColor(self.COLOUR_CODE[Computer.state.fg])
			lprint("_", (Computer.state.cursorX - 1) * self.pixelWidth + tOffset[string.byte("_")] + _conf.terminal_guiScale, (Computer.state.cursorY - 1) * self.pixelHeight + _conf.terminal_guiScale, 0, _conf.terminal_guiScale, _conf.terminal_guiScale)
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
		local x, y = radius + scale6, love.graphics.getHeight() - radius - scale6
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
