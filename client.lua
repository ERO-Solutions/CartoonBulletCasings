local casings = {}
local collectedCasings = {}

-- Preload all weapon shell models
function PreloadModels()
    for _, weaponData in pairs(Config.Weapons) do
        if weaponData.prop then
            RequestModel(weaponData.prop)
            while not HasModelLoaded(weaponData.prop) do Wait(10) end
        end
    end
end

-- Create bullet casings when shooting
CreateThread(function()
    PreloadModels()

    while true do
        local ped = PlayerPedId()
        if IsPedShooting(ped) then
            local weapon = GetSelectedPedWeapon(ped)
            local weaponData = Config.Weapons[weapon]

            if weaponData then
                local pedCoords = GetEntityCoords(ped)
                local propModel = weaponData.prop or `w_pi_singleshot_shell`

                -- Spawn shell randomly on ground around player (1.5 to 3m radius)
                local angle = math.random() * 2 * math.pi
                local radius = 1.5 + math.random() * 1.5
                local spawnX = pedCoords.x + math.cos(angle) * radius
                local spawnY = pedCoords.y + math.sin(angle) * radius

                -- Get ground Z to spawn casing properly on the ground
                local _, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, pedCoords.z + 2.0, false)
                local spawnZ = groundZ + 0.05

                -- Create casing object
                local casing = CreateObject(propModel, spawnX, spawnY, spawnZ, true, true, true)

                -- Disable gravity so it won't roll or fall
                SetEntityHasGravity(casing, false)
                SetEntityCollision(casing, true, true)

                -- Immediately freeze casing to keep it stationary
                FreezeEntityPosition(casing, true)
                SetEntityVelocity(casing, 0.0, 0.0, 0.0)

                -- Random rotation for realism
                SetEntityRotation(casing,
                    math.random() * 360.0,
                    math.random() * 360.0,
                    math.random() * 360.0,
                    2, true
                )

                -- Store casing data for management
                table.insert(casings, {
                    object = casing,
                    coords = vector3(spawnX, spawnY, spawnZ),
                    time = GetGameTimer(),
                    weapon = weapon,
                    shooter = GetPlayerServerId(PlayerId()),
                    hasSettled = true -- Already settled since frozen
                })

                -- Remove oldest casing if exceeding max allowed
                if #casings > Config.MaxCasings then
                    if casings[1].object then DeleteObject(casings[1].object) end
                    table.remove(casings, 1)
                end
            end
        end
        Wait(0)
    end
end)

-- Manage casing cleanup
CreateThread(function()
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())

        for i = #casings, 1, -1 do
            local casing = casings[i]
            if casing.object then
                casing.coords = GetEntityCoords(casing.object)

                -- Remove if too far from player or expired
                if #(playerCoords - casing.coords) > 100.0 or
                   (GetGameTimer() - casing.time > Config.CasingLifetime) then
                    DeleteObject(casing.object)
                    table.remove(casings, i)
                end
            end
        end

        Wait(500)
    end
end)

-- Allow player to pick up casings
CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local foundCasing = false

        for i = #casings, 1, -1 do
            local casing = casings[i]
            if casing.object and #(playerCoords - casing.coords) < Config.PickupDistance then
                foundCasing = true
                ShowHelpNotification("Press ~INPUT_CONTEXT~ to collect casing")

                if IsControlJustReleased(0, 38) then -- E key
                    PlayPickupAnimation()

                    TriggerServerEvent('bulletcasings:collectCasing', {
                        weapon = casing.weapon,
                        shooter = casing.shooter
                    })

                    DeleteObject(casing.object)
                    table.remove(casings, i)

                    ShowNotification("~g~Casing collected")
                    break
                end
            end
        end

        Wait(foundCasing and 0 or 500)
    end
end)

-- Play animation for picking up casings
function PlayPickupAnimation()
    local ped = PlayerPedId()
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do Wait(10) end
    TaskPlayAnim(ped, "pickup_object", "pickup_low", 8.0, -8.0, -1, 0, 0, false, false, false)
    Wait(800)
    ClearPedTasks(ped)
end

-- Show on-screen notification
function ShowNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end

-- Show help notification (like "Press E to...")
function ShowHelpNotification(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
