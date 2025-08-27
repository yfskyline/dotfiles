-- ~/.hammerspoon/init.lua

-- Chain timeout [sec]: press again within this to jump to next state
local CHAIN_TIMEOUT = 0.45 -- sec

-- chain state
-- idx: 0=not started / idx = 1..N=current Stage
local chainLeft= { lastAt = 0, idx = 0 }
local chainRight = { lastAt = 0, idx = 0 }

-- animation: can be 0
hs.window.animationDuration = 0.1

local function quarterRect(f, index) -- index: 0..3(split vertical)
	local qw = f.w / 4
	local x1 = f.x + math.floor(qw * index + 0.5)
	local x2 = f.x + math.floor(qw * (index + 1) + 0.5)
	return { x = x1, y = f.y, w = (x2 - x1), h = f.h }
end

local function leftHalfRect(f)
	return { x = f.x, y = f.y, w = math.floor(f.w / 2 + 0.5), h = f.h }
end

local function rightHalfRect(f)
	local x1 = f.x + math.floor(f.w / 2 + 0.5)
	local x2 = f.x + f.w
	return { x = x1, y = f.y, w = (x2 - x1), h = f.h }
end

local function applyLeftStage(win, stage)
	local f = win:screen():frame()
	if stage == 1 then
		win:setFrame(leftHalfRect(f))
	elseif stage == 2 then
		win:setFrame(quarterRect(f, 0))
	elseif stage == 3 then
		win:setFrame(quarterRect(f, 1))
	end
end

local function applyRightStage(win, stage)
	local f = win:screen():frame()
	if stage == 1 then
		win:setFrame(rightHalfRect(f))
	elseif stage == 2 then
		win:setFrame(quarterRect(f, 3))
	elseif stage == 3 then
		win:setFrame(quarterRect(f, 2))
	end
end

local function handleLeftChain()
	local win = hs.window.focusedWindow()
	if not win then return end

	local now = hs.timer.secondsSinceEpoch()
	if (now - chainLeft.lastAt ) <= CHAIN_TIMEOUT then
		chainLeft.idx = chainLeft.idx + 1
	else
		chainLeft.idx = 1
	end
	chainLeft.lastAt = now

	if chainLeft.idx > 3 then chainLeft.idx = 1 end

	applyLeftStage(win, chainLeft.idx)
end

local function handleRightChain()
	local win = hs.window.focusedWindow()
	if not win then return end

	local now = hs.timer.secondsSinceEpoch()
	if (now - chainRight.lastAt ) <= CHAIN_TIMEOUT then
		-- next stage
		chainRight.idx = chainRight.idx + 1
	else
		-- new chain
		chainRight.idx = 1
	end
	chainRight.lastAt = now

	-- loop within 3 stages
	if chainRight.idx > 3 then chainRight.idx = 1 end

	applyRightStage(win, chainRight.idx)
end

-- bind to keys
hs.hotkey.bind({ "cmd" }, "left", handleLeftChain)
hs.hotkey.bind({ "cmd" }, "right", handleRightChain)
