hs.window.animationDuration = 0.0

local sizes = { 1, 4/3, 3 / 2, 2, 3, 4 }
local fullScreenSizes = { 1, 4 / 3, 2 }

local GRID = { w = 24, h = 24 }
hs.grid.setGrid(GRID.w .. 'x' .. GRID.h)
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

local pressed = {
    up = false,
    down = false,
    left = false,
    right = false
}

function nextStep(dim, cb)
    if hs.window.focusedWindow() then

        local win = hs.window.frontmostWindow()
        local screen = win:screen()

        cell = hs.grid.get(win, screen)

        local nextSize = sizes[3]
        for i = 1, #sizes do
            if cell[dim] == GRID[dim] / sizes[i] then
                nextSize = sizes[(i % #sizes) + 1]
                break
            end
        end

        cb(cell, nextSize)
        hs.grid.set(win, cell, screen)
    end
end

function nextFullScreenStep()
    if hs.window.focusedWindow() then
        local win = hs.window.frontmostWindow()
        local screen = win:screen()

        cell = hs.grid.get(win, screen)

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

hs.hotkey.bind(hyper, "down", function()
    pressed.down = true
    if pressed.up then
        upDownPress()
    else
        nextStep('h', function(cell, nextSize)
            cell.h = GRID.h / nextSize
            cell.y = GRID.h - GRID.h / nextSize
        end)
    end
end, function()
    pressed.down = false
end)

hs.hotkey.bind(hyper, "right", function()
    pressed.right = true
    if pressed.left then
        leftRightPress()
    else
        nextStep('w', function(cell, nextSize)
            cell.x = GRID.w - GRID.w / nextSize
            cell.w = GRID.w / nextSize
        end)
    end
end, function()
    pressed.right = false
end)

hs.hotkey.bind(hyper, "left", function()
    pressed.left = true
    if pressed.right then
        leftRightPress()
    else
        nextStep('w', function(cell, nextSize)
            cell.x = 0
            cell.w = GRID.w / nextSize
        end)
    end
end, function()
    pressed.left = false
end)

hs.hotkey.bind(hyper, "up", function()
    pressed.up = true
    if pressed.down then
        upDownPress()
    else
        nextStep('h', function(cell, nextSize)
            cell.y = 0
            cell.h = GRID.h / nextSize
        end)
    end
end, function()
    pressed.up = false
end)

hs.hotkey.bind(hyper, "f", function()
    nextFullScreenStep()
end)

hs.hotkey.bind(hyper, "i", function()
    local win = hs.window.frontmostWindow()
    local screen = win:screen()
    cell = hs.grid.get(win, screen)
    hs.alert.show(cell)
end)