hs.layout['top60'] = hs.geometry.unitrect(0, 0, 1, 0.6)
hs.layout['right50botHalf'] = hs.geometry.unitrect(0.5, 0.5, 0.5, 0.5)
hs.layout['right50topHalf'] = hs.geometry.unitrect(0.5, 0, 0.5, 0.5)
hs.layout['bot40'] = hs.geometry.unitrect(0, 0.6, 1, 0.4)
hs.layout['left60'] = hs.geometry.unitrect(0, 0, 0.6, 1)

local laptopScreen = "Color LCD"
local curvedScreen = "DELL U3417W"
local verticalScreen = "LEN LT2452pwC"

local threeMonitorLayout = {
    { "Microsoft Outlook", nil, verticalScreen, hs.layout.left50, nil, nil },
    { 'Amazon Chime', nil, verticalScreen, hs.layout.right50topHalf, nil, nil },
    { "Mattermost", nil, verticalScreen, hs.layout.right50botHalf, nil, nil },
    { "IntelliJ IDEA", nil, curvedScreen, hs.layout.right50, nil, nil },
    { "iTerm2", nil, laptopScreen, hs.layout.maximize, nil, nil },
}

local appsToFullScreen = {
    'iTerm2',
    'IntelliJ IDEA',
}

local appsToMinimize = {
    'Skitch',
}

callFunctionOnWindowsByAppName = function(appName, windowFunction, shouldExecuteCheck)
    for _, window in pairs(hs.window.filter.new { appName }:getWindows()) do
        if (not window[shouldExecuteCheck](window)) then
            window[windowFunction](window)
        end
    end
end


setLayout = function()
    local numScreens = table.size(hs.screen.allScreens());
    if (numScreens == 3) then hs.layout.apply(threeMonitorLayout) end

    for _, appName in pairs(appsToFullScreen) do
        callFunctionOnWindowsByAppName(appName, 'setFullScreen', 'isFullScreen')
    end

    for _, appName in pairs(appsToMinimize) do
        callFunctionOnWindowsByAppName(appName, 'isMinimized', 'minimize')
    end
end
