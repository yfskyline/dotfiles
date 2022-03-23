mkdir -p ~/.hammerspoon
cat <<EOH > ~/.hammerspoon/init.lua
hs.window.animationDuration = 0
units = {
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  tr            = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
  br            = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },
  tl            = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  bl            = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 }
}

cmd = { 'cmd' }
mash = { 'ctrl', 'option' }
hs.hotkey.bind(cmd, 'right', function() hs.window.focusedWindow():move(units.right50,    nil, true) end)
hs.hotkey.bind(cmd, 'left', function() hs.window.focusedWindow():move(units.left50,     nil, true) end)
hs.hotkey.bind(mash, '1', function() hs.window.focusedWindow():move(units.tr,         nil, true) end)
hs.hotkey.bind(mash, '4', function() hs.window.focusedWindow():move(units.br,         nil, true) end)
hs.hotkey.bind(mash, '2', function() hs.window.focusedWindow():move(units.tl,         nil, true) end)
hs.hotkey.bind(mash, '3', function() hs.window.focusedWindow():move(units.bl,         nil, true) end)
hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum,    nil, true) end)
EOH
