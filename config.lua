Config = {}

Config.PickupDistance = 1.5
Config.CasingLifetime = 600000 -- 15 mins
Config.MaxCasings = 50

Config.Weapons = {
    [`WEAPON_PISTOL`] = {
        name = "Pistol",
        force = 1.0,
        prop = `w_pi_singleshoth4_shell`
    },
    [`WEAPON_COMBATPISTOL`] = {
        name = "Combat Pistol",
        force = 1.2,
        prop = `w_pi_singleshoth4_shell`
    },
    [`WEAPON_APPISTOL`] = {
        name = "AP Pistol",
        force = 1.5,
        prop = `w_pi_singleshoth4_shell`
    },
    [`WEAPON_SMG`] = {
        name = "SMG",
        force = 2.0,
        prop = `w_pi_singleshot_shell`
    },
    [`WEAPON_ASSAULTRIFLE`] = {
        name = "Assault Rifle",
        force = 2.5,
        prop = `w_pi_singleshot_shell`
    },
    [`WEAPON_CARBINERIFLE`] = {
        name = "Carbine Rifle",
        force = 2.8,
        prop = `w_pi_singleshot_shell`
    }
}
