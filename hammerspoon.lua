-- Define global modifier key of capslock
local hyper = {'shift', 'ctrl', 'alt', 'cmd'}

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install = spoon.SpoonInstall

-- Windows Management
hs.window.animationDuration = 0.1
Install:andUse("MiroWindowsManager", {
  hotkeys = {
    up = {hyper, "up"},
    down = {hyper, "down"},
    right = {hyper, "right"},
    left = {hyper, "left"},
    fullscreen = {hyper, "Return"}
  }
})

-- Variables for Browser Tabs
local appsArray = {
  {'Gmail', 'x', 'browser'},
  {'Calendar', 'c', 'browser'},
  {'Slack', 'a', 'app'},
  {'Visual Studio Code', 'q', 'app'},
  {'iTerm', 'w', 'app'},
  {'Google Chrome', 'e', 'app'},
  {'Tower', 't', 'app'},
  {'Spotify', 's', 'app'},
  {'Things3', 'd', 'app'},
  {'Messages', 'm', 'app'},
  {'Figma', 'f', 'app'},
}
for k,v in pairs(appsArray) do
  hs.hotkey.bind(hyper, v[2], function() focus_a_thing(v, k) end)
end

-- Change volume
function change_system_volume(direction)
  local curVol = hs.audiodevice.defaultOutputDevice():volume()

  if (direction == 'up') then
    curVol = curVol + 5
    hs.audiodevice.defaultOutputDevice():setVolume(curVol)
  elseif (direction == 'down') then
    curVol = curVol - 5
    hs.audiodevice.defaultOutputDevice():setVolume(curVol)
  end
end

-- Bring specifc applications to focus
function focus_application(_app)
  hs.application.launchOrFocus(_app)
end

function focus_tab(index)
  focus_application('Google Chrome')

  if (index > 8) then
    hs.eventtap.keyStroke('cmd', '8')
    hs.eventtap.keyStroke('ctrl', 'tab')
  else
    hs.eventtap.keyStroke('cmd', tostring(index))
  end
end

-- Open App
function focus_a_thing(value, index)
  if (value[3] == 'browser') then
    focus_tab(index)
  else
    focus_application(value[1])
  end
end

-- Hotkeys to trigger window management actions
hs.hotkey.bind(hyper, 'pad1', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind(hyper, 'pad2', function() hs.window.focusedWindow():moveOneScreenEast() end)

-- Hotkeys to trigger Spotify Actions
hs.hotkey.bind(hyper, 'f5', function() hs.spotify.previous() end)
hs.hotkey.bind(hyper, 'f6', function() hs.spotify.playpause() end)
hs.hotkey.bind(hyper, 'f7', function() hs.spotify.next() end)

-- Hotkeys to trigger Volumne Actions (For when not using Mac Keyboard)
hs.hotkey.bind(hyper, '=', function() change_system_volume('up') end)
hs.hotkey.bind(hyper, '-', function() change_system_volume('down') end)

-- Reload config on change
function reloadConfig(paths)
  doReload = false
  for _,file in pairs(paths) do
    if file:sub(-4) == '.lua' then
      print('reloading hammerspoon config')
      doReload = true
      hs.reload()
    end
  end
end

configFileWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/Sites/config-files/hammerspoon.lua', reloadConfig)
configFileWatcher:start()

-- Notify that config is loaded and Hammerspoon is working
hs.notify.show('Hammerspoon', '', 'Config Loaded', '')
