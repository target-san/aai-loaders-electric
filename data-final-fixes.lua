local is_debug_mode = true

local function dbg_log(msg)
    if is_debug_mode then
        log(msg)
    end
end
-- Attempts parse provided string as "aai-...-loader"
-- Returns mid-part of name, if string matches, or nil if it doesn't
-- "aai-loader" results in empty string
local function loader_name(name)
    if name == nil then
        return nil
    end
    if name == "aai-loader" then
        return ""
    end
    if string.sub(name, 1, 4) ~= "aai-" then
        return nil
    end
    name = string.sub(name, 4)
    if string.sub(name, string.len(name) - 6) ~= "-loader" then
        return nil
    end
    return string.sub(name, 1, string.len(name) - 7)
end

local function apply_energy_source(loader)
    dbg_log("Found loader " .. loader.name)

    -- Items per second, according to docs
    local items_per_second = loader.speed * 480
    -- Speed level 1 is 15 items per second, higher tiers are multiples
    local speed_level = items_per_second / 15
    -- Tiers below base are expressed as negative ones, i.e. 7.5 ips is level 0.5, becomes -1
    -- While levels above 1 are shifted, so that 15 ips becomes level 0, with no adjustments to power per item
    if speed_level < 1 then
        speed_level = - (1 / speed_level)
    else
        speed_level = speed_level - 1
    end

    local item_cost = 6000 - 600 * speed_level
    -- buffer for exactly 1 second. Do we need buffer for loader?
    local buffer_cap = items_per_second * item_cost + 2000
    dbg_log("IPS:   " .. items_per_second)
    dbg_log("Level: " .. speed_level)
    dbg_log("JPI:   " .. item_cost)
    dbg_log("Buf:   " .. buffer_cap)

    loader.energy_source = {
        type = "electric",
        buffer_capacity = tostring(buffer_cap) .. "J",
        usage_priority = "secondary-output",
        drain = "2KW",
    }
    loader.energy_per_item = tostring(item_cost) .. "J"
end

for _, loader in pairs(data.raw["loader-1x1"]) do
    local name = loader_name(loader.name)
    -- Affect only AAI loaders
    if name ~= nil then
        apply_energy_source(loader)
    end
end

local function recipe_matches(recipe)
    if recipe == nil then
        return false
    end

    if loader_name(recipe.result) ~= nil then
        return true
    end

    if recipe.results then
        for _, result in pairs(recipe.results) do
            if loader_name(result.name) ~= nil
                or loader_name(result[1]) ~= nil then
                return true
            end
        end
    end

    return recipe_matches(recipe.normal) or recipe_matches(recipe.expensive)
end

local function adjust_recipe(recipe)
    if recipe == nil then
        return
    end

    for _, inp in pairs(recipe.ingredients) do
        if inp.amount ~= nil then
            inp.amount = math.ceil(inp.amount / 5)
        elseif inp[2] ~= nil then
            inp[2] = math.ceil(inp[2] / 5)
        end
    end

    adjust_recipe(recipe.normal)
    adjust_recipe(recipe.expensive)
end

for _, recipe in pairs(data.raw["recipe"]) do
    if recipe_matches(recipe) then
        dbg_log("Found loader recipe!")
        dbg_log(serpent.block(recipe))
        adjust_recipe(recipe)
        dbg_log("Adjusted to:")
        dbg_log(serpent.block(recipe))
    end
end
