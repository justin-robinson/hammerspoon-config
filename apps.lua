dofile 'table.lua'

-- ensure these apps are open and have at least one window
local appsToOpen = {
    'iTerm2',
    'Amazon Chime',
    'IntelliJ IDEA',
    'Google Chrome',
    'Mattermost',
    'Microsoft Outlook',
    'Skitch'
}

for _, appName in pairs(appsToOpen) do
    local app = hs.window.filter.new { appName }:getWindows()
    if (app == nil or table.size(app) == 0) then
        -- open and block until the window appears
        hs.application.open(appName, 0, true)
    end
end

-- open amazon profile for chrome
local focusedWindow = hs.window.focusedWindow()
print(focusedWindow)
local chrome = hs.appfinder.appFromName 'Google Chrome'
if (chrome) then
    local str_people = { "People", "Amazon" }
    local amazon = chrome:findMenuItem(str_people)
    if (amazon and not amazon["ticked"]) then
        chrome:selectMenuItem(str_people)
    end
end
if (focusedWindow) then
    focusedWindow:focus()
end