hyper = { "ctrl", "alt", "cmd" }
hypershift = { "ctrl", "alt", "cmd", "shift" }

require 'window.position'

hs.hotkey.bind(hyper, 'l', setLayout)
--hs.hotkey.bind(hyper, 'f', maximizeCurrentWindow)
hs.hotkey.bind(hyper, 'm', minimizeCurrentWindow)