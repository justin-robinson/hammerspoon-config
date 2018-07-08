maximizeCurrentWindow = function()
    maximizeWindow(hs.window.focusedWindow())
end

maximizeWindow = function(window)
    if window ~= nil then
        window:setFullScreen(true)
    end
end

minimizeCurrentWindow = function()
    minimizeWindow(hs.window.focusedWindow())
end

minimizeWindow = function(window)
    if window ~= nil then
        window:minimize(true)
    end
end