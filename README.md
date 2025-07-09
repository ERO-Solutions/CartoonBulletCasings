Bullet Casing System for FiveM

This script adds immersive bullet casing effects to your FiveM server. When a player fires a weapon, bullet casings are ejected and dropped on the ground. Casings can be picked up by players, adding realism and investigative roleplay possibilities for police or forensic systems.

## Features

- Real-time shell ejection for configurable weapons.
- Each casing spawns as a physical object with random rotation.
- Casings remain on the ground for up to 15 minutes (configurable).
- Players can collect nearby casings with an animation.
- Limits the maximum number of casings to maintain performance.
- Configurable shell models and force per weapon.

---
How To Use
1. Find Bullet Casings & Pick Them Up With E
2. Type /casingcheck
3. Check In the chat and the ballistics should pop up with the shooter id

Installation

1. **Add the script to your `resources` folder.**

2. Ensure the folder has a `fxmanifest.lua` file and includes:
   ```lua
   client_script 'client.lua'
   shared_script 'config.lua'
