local collectedCasings = {}

-- Get the shared config (make sure this matches your config file)
local Config = {
    Weapons = {
        [`WEAPON_PISTOL`] = { name = "Pistol" },
        [`WEAPON_COMBATPISTOL`] = { name = "Combat Pistol" },
        [`WEAPON_APPISTOL`] = { name = "AP Pistol" },
        [`WEAPON_SMG`] = { name = "SMG" },
        [`WEAPON_ASSAULTRIFLE`] = { name = "Assault Rifle" }
    }
}

-- Register the /casingcheck command
RegisterCommand('casingcheck', function(source, args, rawCommand)
    TriggerEvent('bulletcasings:checkCasings', source)
end, false)

-- Event for collecting casings
RegisterNetEvent('bulletcasings:collectCasing')
AddEventHandler('bulletcasings:collectCasing', function(casingData)
    local src = source
    
    if not casingData or not casingData.weapon then 
        print("^1[ERROR] Invalid casing data from player "..src)
        return 
    end
    
    if not collectedCasings[src] then
        collectedCasings[src] = {}
    end
    
    table.insert(collectedCasings[src], {
        weapon = casingData.weapon,
        shooter = casingData.shooter or src, -- Default to collector if no shooter
        time = os.time()
    })
    
    print(("^2[DEBUG] Player %s collected %s casing (shooter: %s)"):format(
        src, 
        Config.Weapons[casingData.weapon] and Config.Weapons[casingData.weapon].name or "Unknown", 
        casingData.shooter or "unknown"
    ))
end)

-- Event to check casings
RegisterNetEvent('bulletcasings:checkCasings')
AddEventHandler('bulletcasings:checkCasings', function(source)
    local src = source
    
    if not collectedCasings[src] or #collectedCasings[src] == 0 then
        TriggerClientEvent('chat:addMessage', src, {
            args = {"[BALLISTICS]", "No casings collected!"}
        })
        return
    end

    TriggerClientEvent('chat:addMessage', src, {
        args = {"[BALLISTICS]", string.format("Collected %d casings:", #collectedCasings[src])}
    })
    
    for i, casing in ipairs(collectedCasings[src]) do
        local weaponName = Config.Weapons[casing.weapon] and Config.Weapons[casing.weapon].name 
                          or ("Hash: "..casing.weapon)
        
        TriggerClientEvent('chat:addMessage', src, {
            args = {
                "[Casing #"..i.."]", 
                string.format("Weapon: %s | Shooter ID: %s", weaponName, casing.shooter)
            }
        })
    end
    
    collectedCasings[src] = nil -- Clear after showing
end)

AddEventHandler('playerDropped', function()
    collectedCasings[source] = nil
end)