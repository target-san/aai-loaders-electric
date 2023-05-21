# AAI Loaders: Electric power

Makes all loaders created by [Earendel's AAI Loaders](https://mods.factorio.com/mod/aai-loaders) mod
powered via electricity rather than being free or requiring lubricant

## Details

- AAI Loaders mod is forced into "expensive" unlubricated mode,
    to make sure its lubricant supply scripting won't even try to run.
- Unlubricated recipes adjusted to cost roughly 5 times less. Powering with electricity
    is itself simpler than supplying lubricant, so making loaders roughly 2 times more
    expensive than lubricant mode looks fair enough
- All loaders now use Factorio's native energy system via "energy_source" property.
    This makes them run at native speeds. No scripting.
- Base cost of each item transported is 6kJ, yet it lowers slightly with each speed
    tier above 15 items/s. As a result, normal loader is 92kW, fast is ~160kW and express is 218kW.

## Known shortcomings

- Loaders description says they have no cost. This is because localization wasn't touched at all
- Recipe adjustment logic is very primitive, so may not always play as desired

## Plans

- Make lubricated mode work again, via Factorio's native power system
- Balancing
- Introduce recipes and localization overrides

## Special thanks

- Wube, for the awesome game
- Earendel, for awesome standalone loaders mod
