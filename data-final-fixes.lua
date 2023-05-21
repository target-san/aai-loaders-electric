local function apply_energy_source(loader)
    log("Found loader " .. loader.name)

    loader.energy_source = {
        type = "electric",
        buffer_capacity = "100KJ",
        usage_priority = "secondary-output",
        drain = "2KW",
    }
    loader.energy_per_item = "6KJ"
end

for _, loader in pairs(data.raw["loader-1x1"]) do
    local name = loader.name
    -- Affect only AAI loaders
    if string.sub(name, 1, 4) == "aai-"
        and string.sub(name, string.len(name) - 6) == "-loader"
    then
        apply_energy_source(loader)
    end
end
