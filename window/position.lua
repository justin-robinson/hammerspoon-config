hs.window.animationDuration = 0.0

local sizeDenominators = { 1, 4/3, 3/2, 2, 3, 4 }
local fullScreenSizes = { 1, 4/3, 2 }

local GRID = { w = 24, h = 24 }
hs.grid.setGrid(GRID.w .. 'x' .. GRID.h)
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

local pressedLastTime = 0
local pressed = 0

local UP = 8
local DOWN = 4
local LEFT = 2
local RIGHT = 1

local numKeysPressedLastTime = 0
local numKeysPressed = 0

hs.hotkey.bind(hyper, "up", function()
    press(UP)
    if isPressed(DOWN) then
        upDownPress()
    else
        nextStep('h', function(cell, nextSize)
            cell.y = 0
            cell.h = GRID.h / nextSize
        end)
    end
end, function()
    release(UP)
end)

hs.hotkey.bind(hyper, "down", function()
    press(DOWN)
    if isPressed(UP) then
        upDownPress()
    else
        nextStep('h', function(cell, nextSize)
            cell.h = GRID.h / nextSize
            cell.y = GRID.h - GRID.h / nextSize
        end)
    end
end, function()
    release(DOWN)
end)

hs.hotkey.bind(hyper, "right", function()
    press(RIGHT)
    if isPressed(LEFT) then
        leftRightPress()
    else
        nextStep('w', function(cell, nextSize)
            cell.x = GRID.w - GRID.w / nextSize
            cell.w = GRID.w / nextSize
        end)
    end
end, function()
    release(RIGHT)
end)

hs.hotkey.bind(hyper, "left", function()
    press(LEFT)
    if isPressed(RIGHT) then
        leftRightPress()
    else
        nextStep('w', function(cell, nextSize)
            cell.x = 0
            cell.w = GRID.w / nextSize
        end)
    end
end, function()
    release(LEFT)
end)

function press(KEY)
    pressed = pressed | KEY
    numKeysPressed = numberOfPressedKeys(pressed)
end

function release(KEY)
    pressed = pressed ~ KEY
    numKeysPressed = numberOfPressedKeys(pressed)
end


function upDownPress()
    nextStep('h', function(cell, nextSize)
        cell.h = GRID.h / nextSize
        cell.y = (GRID.h - cell.h) / 2
    end)
end

function leftRightPress()
    nextStep('w', function(cell, nextSize)
        cell.w = GRID.w / nextSize
        cell.x = (GRID.w - cell.w) / 2
    end)
end

function nextStep(dim, cb)
    if hs.window.focusedWindow() then
        local win = hs.window.frontmostWindow()
        local screen = win:screen()

        local cell = hs.grid.get(win, screen)

        local nextSize
        if pressed == keysPressedThisTimeAndLastTime() then
            for i=1, #sizeDenominators do
                if cell[dim] == GRID[dim] / sizeDenominators[i] then
                    nextSize = sizeDenominators[(i % #sizeDenominators) + 1]
                    break
                end
            end
        elseif numKeysPressed == 1 then
            nextSize = sizeDenominators[4]
        elseif numKeysPressed == 2 then
            nextSize = 1
        end

        if numKeysPressed == 1 and nextSize == sizeDenominators[1] then
            nextSize = sizeDenominators[2]
        end

        cb(cell, nextSize)
        hs.grid.set(win, cell, screen)

        numKeysPressedLastTime = numberOfPressedKeys(pressedLastTime)
        pressedLastTime = pressed
    end
end

function numberOfPressedKeys(pressed)
    local numberOfPressedKeysCount = 0

    while pressed~=0 do
        numberOfPressedKeysCount = numberOfPressedKeysCount + 1
        pressed = pressed & (pressed - 1)
    end
    return numberOfPressedKeysCount
end

function nextFullScreenStep()
    if hs.window.focusedWindow() then
        local win = hs.window.frontmostWindow()
        local screen = win:screen()

        local cell = hs.grid.get(win, screen)

        local nextSize = fullScreenSizes[1]
        for i = 1, #fullScreenSizes do
            if cell.w == GRID.w / fullScreenSizes[i] and
                    cell.h == GRID.h / fullScreenSizes[i] and
                    cell.x == (GRID.w - GRID.w / fullScreenSizes[i]) / 2 and
                    cell.y == (GRID.h - GRID.h / fullScreenSizes[i]) / 2 then
                nextSize = fullScreenSizes[(i % #fullScreenSizes) + 1]
                break
            end
        end

        cell.w = GRID.w / nextSize
        cell.h = GRID.h / nextSize
        cell.x = (GRID.w - GRID.w / nextSize) / 2
        cell.y = (GRID.h - GRID.h / nextSize) / 2

        hs.grid.set(win, cell, screen)
    end
end


hs.hotkey.bind(hyper, "f", function()
    nextFullScreenStep()
end)

hs.hotkey.bind(hyper, "i", function()
    local win = hs.window.frontmostWindow()
    local screen = win:screen()
    cell = hs.grid.get(win, screen)
    hs.alert.show(cell)
end)

function isPressed(KEY)
    return pressed&KEY ~= 0
end

function keysPressedThisTimeAndLastTime()
    return pressed&pressedLastTime
end