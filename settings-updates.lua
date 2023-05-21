-- Patch aai-loaders' mode to be always 'expensive'
-- This is needed to disable aai-loaders' scripted fluid supply
-- and patch them to use electricity
local loaders_mode = data.raw["string-setting"]["aai-loaders-mode"]

loaders_mode.hidden = true
loaders_mode.allowed_values = {"expensive"}
loaders_mode.default_value = "expensive"
