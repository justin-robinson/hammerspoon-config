require 'window.functions'

hs.layout['top60'] = hs.geometry.unitrect(0, 0, 1, 0.6)
hs.layout['right50botHalf'] = hs.geometry.unitrect(0.5, 0.5, 0.5, 0.5)
hs.layout['right50topHalf'] = hs.geometry.unitrect(0.5, 0, 0.5, 0.5)
hs.layout['bot40'] = hs.geometry.unitrect(0, 0.6, 1, 0.4)
hs.layout['left60'] = hs.geometry.unitrect(0, 0, 0.6, 1)

local laptopScreen = hs.screen(69734402)
local primaryScreen = hs.screen(188992195)
local secondaryScreen = hs.screen(188992197)

local threeMonitorLayout = {
    { 'Microsoft Outlook', nil, laptopScreen, hs.layout.maximize, nil, nil },
    { 'Amazon Chime', nil, laptopScreen, hs.layout.right50, nil, nil },
    { 'Mattermost', nil, laptopScreen, hs.layout.left50, nil, nil },
    { 'iTerm2', nil, secondaryScreen, hs.layout.maximize, nil, nil },
}

local appsToFullScreen = {
    'iTerm2',
    'Microsoft Outlook',
}

local appsToMinimize = {
    'Skitch',
}

callFunctionOnWindowsByAppName = function(appName, fn)
    for _, window in pairs(hs.window.filter.new { appName }:getWindows()) do
        fn(window)
    end
end


setLayout = function()
    local numScreens = table.size(hs.screen.allScreens());
    if (numScreens == 3) then
        primaryScreen:setPrimary()
        hs.layout.apply(threeMonitorLayout)
    end

    for _, appName in pairs(appsToFullScreen) do
        callFunctionOnWindowsByAppName(appName, maximizeWindow)
    end

    for _, appName in pairs(appsToMinimize) do
        callFunctionOnWindowsByAppName(appName, minimizeWindow)
    end
end